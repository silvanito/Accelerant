xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"
xml <<  render(:partial => return_partial_name(@flex_module))

