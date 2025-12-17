task :hello do
  puts 'Hello, World!'
end

task :hello2, :foo, :bar do |t, args|
  puts t
  puts args
end

task :hello3, %i[foo bar] => :environment do |t, args|
  puts t
  puts args
end

task hello4: :environment do |t, args|
  puts t
  puts args
end
