# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  Movie.destroy_all
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
	#puts "e1:" + page.body.index(e1).to_s
	#puts "e2:"+ page.body.index(e2).to_s
	page.body.index(e1).should < page.body.index(e2)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.gsub(/ /, '').split(",").each do |rating| 
	uncheck ? uncheck("ratings_" + rating) : check("ratings_" + rating);
  end
end

When /I press (.*) button/ do |button|
	click_button("ratings_" + button)
end

Then /I should see that (.*) movies are( not)? visible/ do |rating_list, is_or_not|
	rating_list_db = page.all(:xpath, '//table[@id="movies"]/tbody/tr/td[2]')
	rating_list.gsub(/ /, '').split(",").each do |rating| 
		count=0
		rating_list_db.each do |rating_db|
			#puts rating_db.text + ", " + rating
			if rating_db.text == rating
				count+=1
			end
		end
		is_or_not ? count.should == 0 : count.should > 0
		#puts("Total for " + rating + ":" + count.to_s )
	end
end

Then /I should see all of the movies/ do 
	countHTML = page.all(:xpath, '//table[@id="movies"]/tbody/tr').count
	countDB =  Movie.count
	#puts("CountHTML:" + countHTML.to_s  + ", countDB" + countDB.to_s )
	countHTML.should == countDB
end