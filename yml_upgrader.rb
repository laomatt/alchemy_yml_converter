require 'yaml'

original_yaml = YAML::load_file('original_elements.yml')


out = []
convert = lambda do |sect|
  out_sect = {}
  sect.each do |k,v|
    if k == 'contents'
      out_sect['ingredients'] = begin
        if v.class == Array
          o = []
          v.each do |ha|
            w = {}
            ha.each do |gn,mn|
              new_mn = begin
                if mn == 'EssenceDate'
                  'Datetime'
                elsif mn.class == String
                  mn.gsub('Essence','')
                else
                  mn
                end
              end


              if gn == 'name'
                w['role'] = new_mn
              else
                w[gn] = new_mn
              end
            end
            o << w
          end

          o
        else
          v
        end        
        
      end
    else
      out_sect[k] = v
    end
  end

  out_sect
end

original_yaml.each do |section|
  out << convert.call(section)
end


p out
File.open("new_elements.yml", "w+") {|f|
  f.write(out.to_yaml)

}