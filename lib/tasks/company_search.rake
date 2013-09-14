task :search_company, [:user_id,:company,:start] => :environment do |t, args|
  current_user = User.find(args.user_id)
  return unless auth = current_user.authentications.where(provider: 'linkedin').first
  helper = LinkedInHelper.new(auth)

  company = args.company.split("_").join(" ")
  start = args.start.to_i || 0

  puts "search company contacts"
  return unless profiles = helper.company_profiles(company, start)

  puts "expand contacts to find mutual connections"
  profiles = helper.expand_company_profiles(profiles)

  connections = LinkedInHelper.parse_company_profiles(profiles)

  file_name = "#{company}_#{start}.csv"
  puts "saving #{connections.count} rows to file: #{file_name}"
  LinkedInHelper.to_file(file_name, connections)
end

task :search_companies, [:user_id,:company_file] => :environment do |t, args|
  current_user = User.find(args.user_id)
  return unless auth = current_user.authentications.where(provider: 'linkedin').first
  helper = LinkedInHelper.new(auth)

  companies = CSV.read(args.company_file).flatten.map{ |c| c.gsub(/Co\.|LLC|Inc\.|USA|Inc|Corp\.|/, '').strip }
  connections = []
  companies.each do |company|
    start = 0

    begin
      puts "searching #{company} - #{start}"
      next unless profiles = helper.company_profiles(company, start)

      puts "...expand profile"
      profiles = helper.expand_company_profiles(profiles)
      connections << LinkedInHelper.parse_company_profiles(profiles)

      start += 25
    end while profiles.try(:count) == 25
  end

  puts "saving #{connections.count} rows to file: #{file_name}"
  LinkedInHelper.to_file("company_connections_#{Time.zone.now.to_i}.csv", connections)

end
