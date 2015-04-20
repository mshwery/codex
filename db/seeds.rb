require 'nokogiri'

def get_text_node(node)
  text = nil

  if node and node.text
    text = node.text
  end

  text
end

def create_diagnosis(node, parent_id=nil)

  if !node or node.name != 'diag'
    return
  end

  code = get_text_node(node.at('name'))
  description = get_text_node(node.at('desc'))

  puts "creating diagnosis: #{code}"

  diagnosis = Diagnosis.new({
    code: code,
    description: description,
    diagnosis_id: parent_id
  })

  if diagnosis.save!
    # look for a child and sibling
    child = node.at('diag')
    sibling = node.next_element

    # step into the child and recursively call this method
    create_diagnosis(child, diagnosis.id)

    # step over to the sibling and recursively call this method
    create_diagnosis(sibling)
  else
    puts "* error creating code: #{code} #{description}"
  end

end

puts "********Seeding Data Start************"

file = File.read(Rails.root.join('public/2015/FY15_Tabular.xml'))
doc = Nokogiri::XML(file)

sections = doc.search('//section')

ActiveRecord::Base.transaction do
  sections.each do |section|
    puts "creating diagnoses for section: #{section.attr('id')}"
    puts "============="

    # look for the first diag and create it
    create_diagnosis(section.at('diag'))
  end
end

# loop thru sections and grab each main diag section
# diagnoses = sections.map{ |section| section.css('diag') }

# # limit to take only 10 for testing this
# flattened = diagnoses.flatten(1) # .take(10)

# puts "Starting transaction for #{flattened.size} diagnoses"

# loop thru main diag blocks for each subdiag (the actual code and desc)
# ActiveRecord::Base.transaction do
#   flattened.each do |d|
#     code = d.at('name')
#     description = d.at('desc')

#     if name and description
#       diagnosis = Diagnosis.create({
#         code: code.text,
#         description: description.text
#       })

#       if !diagnosis
#         puts "* error creating code: #{code.text} #{description.text}"
#       end
#     end
#   end
# end

puts "********Seeding Data End************"
