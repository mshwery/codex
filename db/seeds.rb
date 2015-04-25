require 'nokogiri'
#require 'stopwords'

# def stopwords
#   Terminology::STOPWORDS
# end

# def file
#   File.read(Rails.root.join('public/2015/FY15_Tabular.xml')).to_s
# end

# def xml_doc
#   Nokogiri::XML(file).to_s
# end

def get_text_node(node)
  text = nil

  if node and node.text
    text = node.text
  end

  text
end

def create_diagnosis(node, parent_id=nil, section_id=nil)

  if !node or node.name != 'diag'
    return
  end

  code = get_text_node(node.at('name'))
  description = get_text_node(node.at('desc'))

  puts "creating diagnosis: #{code}"

  diagnosis = Diagnosis.new({
    code: code,
    description: description,
    diagnosis_id: parent_id,
    section_id: section_id
  })

  if diagnosis.save!
    # look for a child and sibling
    child = node.at('diag')
    sibling = node.next_element

    create_inclusions(node, diagnosis.id)
    create_exclusions(node, diagnosis.id)

    # step into the child and recursively call this method
    create_diagnosis(child, diagnosis.id)

    # step over to the sibling and recursively call this method
    create_diagnosis(sibling, nil, section_id)
  else
    puts "* error creating code: #{code} #{description}"
  end

end

def create_inclusions(node, diagnosis_id)
  # find the node's <inclusionTerm> or <includes>
  includes = node.at('> inclusionTerm') || node.at('> includes')

  if includes
    includes.search('note').each do |params|
      note = Inclusion.create({
        note: params.text,
        diagnosis_id: diagnosis_id
      })
    end
  end
end

def create_exclusions(node, diagnosis_id)
  # find the node's <excludes1> or <excludes2>
  excludes1 = node.at('> excludes1')
  excludes2 = node.at('> excludes2')

  create_exclusion_notes(excludes1, 1, diagnosis_id)
  create_exclusion_notes(excludes2, 2, diagnosis_id)
end

def create_exclusion_notes(exclusions, exclusion_type, diagnosis_id)
  if exclusions
    exclusions.search('note').each do |params|
      exclusion = Exclusion.create({
        note: params.text,
        diagnosis_id: diagnosis_id,
        exclusion_type: exclusion_type
      })
    end
  end
end

#doc = xml_doc
file = File.read(Rails.root.join('public/2015/FY15_Tabular.xml'))
doc = Nokogiri::XML(file)

ActiveRecord::Base.transaction do
  puts "********Diagnosis Data Start************"
  
  doc.search('//section').each do |section|

    section_range = section.attr('id')
    section_codes = section_range.split('-')
    first_code = section_codes[0]
    last_code = section_codes[1] || first_code
    section_title = get_text_node(section.at('> desc'))

    s = Section.create({
      code_range: section_range,
      first_code: first_code,
      last_code: last_code,
      title: section_title
    })

    puts "creating diagnoses for section: #{section_range}"
    puts "============="

    # look for the first diag and create it
    create_diagnosis(section.at('diag'), nil, s.id)
  end

  puts "********Diagnosis Data End************"
end

## get medical terms
#terms = doc.search

