require 'nokogiri'

puts "********Seeding Data Start************"

file = File.read(Rails.root.join('public/2015/FY15_Tabular.xml'))
doc = Nokogiri::XML(file)

blocks = doc.search('//section')

# loop thru sections and grab each main diag block
diagnoses = blocks.map{ |block| block.css('diag') }

# limit to take only 10 for testing this
flattened = diagnoses.flatten(1) # .take(10)

puts "Starting transaction for #{flattened.size} diagnoses"

# loop thru main diag blocks for each subdiag (the actual code and desc)
ActiveRecord::Base.transaction do
  flattened.each do |d|
    code = d.at('name')
    description = d.at('desc')

    if name and description
      diagnosis = Diagnosis.create({
        code: code.text,
        description: description.text
      })

      if !diagnosis
        puts "* error creating code: #{code.text} #{description.text}"
      end
    end
  end
end

puts "********Seeding Data End************"

