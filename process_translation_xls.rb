require 'spreadsheet'    
Spreadsheet.open('fishdata—nikky.xls') do |book|
  book.worksheet(0).each do |row|
    break if row[0].nil?
    content = row.join('|')
    puts "\"" + content.split("|")[0] + "\" = \"" + content.split("|")[-1] + "\";"
  end
end
