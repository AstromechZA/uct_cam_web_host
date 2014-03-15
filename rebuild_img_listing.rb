require 'yaml'
require 'fileutils'

# path stuff
current_dir = File.dirname(__FILE__)

# load config
cnf = YAML::load_file(File.join(current_dir, 'config.yml'))
puts cnf.inspect

# time stamp array
tsa = []

# create img dir
Dir.mkdir(File.join(cnf['img_dir'])) if not File.directory?(cnf['img_dir'])

Dir.glob(File.join(cnf['img_dir'], '*.jpg')) do |f|
    m = File.basename(f).match(/img(\d*)\.jpg/)
    if m
        tsa << m[1].to_i
    end
end

# sort timestamps in reverse
tsa = tsa.uniq.sort.reverse

# select top n
tsa = tsa[0, cnf['num_img']]

# delete those that aren't needed
Dir.glob(File.join(cnf['img_dir'], '*.jpg')) do |f|
    m = File.basename(f).match(/((img)|(thumb))(\d*)\.jpg/)
    if m
        if not tsa.include? m[4].to_i
            File.delete(f)
            puts "deleting #{f}"
        end
    end
end

# build images javascript
imgs = []
tsa.each do |ts|
    imgs << [Time.at(ts).asctime, "img#{ts}.jpg","thumb#{ts}.jpg"]
end
js = "var imagearray = #{imgs.inspect};"

# create js dir
Dir.mkdir(File.join(cnf['js_dir'])) if not File.directory?(cnf['js_dir'])

# write out
outf = File.join(cnf['js_dir'], 'dataset.js')
File.open(outf, 'w') {|f| f.write(js) }

# copy latest img to latest
File.delete(File.join(cnf['img_dir'], 'latest.jpg')) if File.exists?(File.join(cnf['img_dir'], 'latest.jpg'))
if imgs.length > 0
    FileUtils.cp(File.join(cnf['img_dir'], "img#{tsa[0]}.jpg"), File.join(cnf['img_dir'], 'latest.jpg'))
end