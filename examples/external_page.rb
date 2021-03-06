require '../lib/rturk'

props = {:Title=>"Write a twitter update", 
         :MaxAssignments=>1, :LifetimeInSeconds=>3600, 
         :Reward=>{:Amount=>0.10, :CurrencyCode=>"USD"}, 
         :Keywords=>"twitter, blogging, writing, english", 
         :Description=>"Simply write a twitter update for me",
         :RequesterAnnotation=>"OptionalNote",
         :AssignmentDurationInSeconds=>3600, :AutoApprovalDelayInSeconds=>3600, 
         :QualificationRequirement=>[{
           :QualificationTypeId=>"000000000000000000L0", 
           :IntegerValue=>90, 
           :Comparator=>"GreaterThan", 
           :RequiredToPreview=>"false"
           }]
        }
root = File.expand_path(File.dirname(__FILE__))
aws = YAML.load(File.open(File.join(root, 'mturk.yml')))
@turk = RTurk::Requester.new(aws['AWSAccessKeyId'], aws['AWSAccessKey'], :sandbox => true)
page = RTurk::ExternalQuestionBuilder.build("http://s3.amazonaws.com/mpercival.com/newtweet.html", :id => 'foo')

puts "*" * 80
puts "This is the XML created for the external page question \n #{page}"

puts "*" * 80
hit = @turk.create_hit(props, page)
puts "And the response from CreateHIT operation"
p hit

puts "*" * 80
puts "Created a new HIT which can be found at #{@turk.url_for_hit_type(hit['HIT']['HITTypeId'])}"

File.open(File.join(root ,"last_hit"), "w") {|f| f.write(hit['HIT']['HITId']) }