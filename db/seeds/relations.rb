Relation.delete_all
rln =[]

rln << {:id => 0, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Region::Const::Moskva, :children => [Category::Region::Const::Moskovskaya_oblast],:name => 'Beeline, Moscow home regions'}
rln << {:id => 1, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Region::Const::Moskovskaya_oblast, :children => [Category::Region::Const::Moskva],:name => 'Beeline, Moscow region home regions'}
rln << {:id => 2, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Region::Const::Sankt_peterburg, :children => [Category::Region::Const::Leningradskaya_oblast],:name => 'Beeline, Piter home regions'}
rln << {:id => 3, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Region::Const::Leningradskaya_oblast, :children => [Category::Region::Const::Sankt_peterburg],:name => 'Beeline, Piter region home regions'}
rln << {:id => 4, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Region::Const::Ekaterinburg, :children => [Category::Region::Const::Sverdlovskaya_oblast],:name => 'Beeline, Ekaterinburg home regions'}
rln << {:id => 5, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Region::Const::Sverdlovskaya_oblast, :children => [Category::Region::Const::Ekaterinburg],:name => 'Beeline, Ekaterinburg region home regions'}

rln << {:id => 1000, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Region::Const::Moskva, :children => [Category::Region::Const::Moskovskaya_oblast],:name => 'Megafon, Moscow home regions'}
rln << {:id => 1001, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Region::Const::Moskovskaya_oblast, :children => [Category::Region::Const::Moskva],:name => 'Megafon, Moscow region home regions'}
rln << {:id => 1002, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Region::Const::Sankt_peterburg, :children => [Category::Region::Const::Leningradskaya_oblast],:name => 'Megafon, Piter home regions'}
rln << {:id => 1003, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Region::Const::Leningradskaya_oblast, :children => [Category::Region::Const::Sankt_peterburg],:name => 'Megafon, Piter region home regions'}
rln << {:id => 1004, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Region::Const::Ekaterinburg, :children => [Category::Region::Const::Sverdlovskaya_oblast],:name => 'Megafon, Ekaterinburg home regions'}
rln << {:id => 1005, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Region::Const::Sverdlovskaya_oblast, :children => [Category::Region::Const::Ekaterinburg],:name => 'Megafon, Ekaterinburg region home regions'}

rln << {:id => 2000, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => Category::Region::Const::Moskva, :children => [Category::Region::Const::Moskovskaya_oblast],:name => 'MTS, Moscow home regions'}
rln << {:id => 2001, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => Category::Region::Const::Moskovskaya_oblast, :children => [Category::Region::Const::Moskva],:name => 'MTS, Moscow region home regions'}
rln << {:id => 2002, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => Category::Region::Const::Sankt_peterburg, :children => [Category::Region::Const::Leningradskaya_oblast],:name => 'MTS, Piter home regions'}
rln << {:id => 2003, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => Category::Region::Const::Leningradskaya_oblast, :children => [Category::Region::Const::Sankt_peterburg],:name => 'MTS, Piter region home regions'}
rln << {:id => 2004, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => Category::Region::Const::Ekaterinburg, :children => [Category::Region::Const::Sverdlovskaya_oblast],:name => 'MTS, Ekaterinburg home regions'}
rln << {:id => 2005, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => Category::Region::Const::Sverdlovskaya_oblast, :children => [Category::Region::Const::Ekaterinburg],:name => 'MTS, Ekaterinburg region home regions'}

rln << {:id => 3000, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => Category::Region::Const::Moskva, :children => [Category::Region::Const::Moskovskaya_oblast],:name => 'Теле2, Moscow home regions'}
rln << {:id => 3001, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => Category::Region::Const::Moskovskaya_oblast, :children => [Category::Region::Const::Moskva],:name => 'Теле2, Moscow region home regions'}
rln << {:id => 3002, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => Category::Region::Const::Sankt_peterburg, :children => [Category::Region::Const::Leningradskaya_oblast],:name => 'Теле2, Piter home regions'}
rln << {:id => 3003, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => Category::Region::Const::Leningradskaya_oblast, :children => [Category::Region::Const::Sankt_peterburg],:name => 'Теле2, Piter region home regions'}
rln << {:id => 3004, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => Category::Region::Const::Ekaterinburg, :children => [Category::Region::Const::Sverdlovskaya_oblast],:name => 'Теле2, Ekaterinburg home regions'}
rln << {:id => 3005, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => Category::Region::Const::Sverdlovskaya_oblast, :children => [Category::Region::Const::Ekaterinburg],:name => 'Теле2, Ekaterinburg region home regions'}

rln << {:id => 9000, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => Category::Country::Const::Mir, :children => Category::Country::Const::World_countries_without_russia,:name => 'World'}
rln << {:id => 9001, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => Category::Country::Const::Evropa, :children => Category::Country::Const::Europe_countries_without_russia,:name => 'Europe'}
rln << {:id => 9002, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => Category::Country::Const::Asia, :children => Category::Country::Const::Asia_countries,:name => 'Asia'}
rln << {:id => 9003, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => Category::Country::Const::Severnaya_Amerika, :children => Category::Country::Const::Noth_america_countries,:name => 'Noth America'}
rln << {:id => 9004, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => Category::Country::Const::Ugnaya_Amerika, :children => Category::Country::Const::South_america_countries,:name => 'South America'}
rln << {:id => 9005, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => Category::Country::Const::Afrika, :children => Category::Country::Const::Africa_countries,:name => 'Africa'}
rln << {:id => 9006, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => nil, :children => Category::Country::Mts::Sic_countries,:name => 'CIS'}

rln << {:id => 10000, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Country::Const::Mir, :children => Category::Country::Const::World_countries_without_russia,:name => 'Beeline, World'}
rln << {:id => 10001, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Country::Const::Evropa, :children => Category::Country::Const::Europe_countries_without_russia,:name => 'Beeline, Europe'}
rln << {:id => 10002, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Country::Const::Asia, :children => Category::Country::Const::Asia_countries,:name => 'Beeline, Asia'}
rln << {:id => 10003, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Country::Const::Mir, :children => Category::Country::Const::Noth_america_countries,:name => 'Beeline, Noth America'}
rln << {:id => 10004, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Country::Const::Ugnaya_Amerika, :children => Category::Country::Const::South_america_countries,:name => 'Beeline, South America'}
rln << {:id => 10005, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => Category::Country::Const::Afrika, :children => Category::Country::Const::Africa_countries,:name => 'Beeline, Africa'}
rln << {:id => 10006, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => Category::Country::Mts::Sic_countries,:name => 'Beeline, CIS'}

rln << {:id => 10100, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Country::Const::Mir, :children => Category::Country::Const::World_countries_without_russia,:name => 'Megafon, World'}
rln << {:id => 10101, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Country::Const::Evropa, :children => Category::Country::Const::Europe_countries_without_russia,:name => 'Megafon, Europe'}
rln << {:id => 10102, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Country::Const::Asia, :children => Category::Country::Const::Asia_countries,:name => 'Megafon, Asia'}
rln << {:id => 10103, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Country::Const::Severnaya_Amerika, :children => Category::Country::Const::Noth_america_countries,:name => 'Megafon, Noth America'}
rln << {:id => 10104, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Country::Const::Ugnaya_Amerika, :children => Category::Country::Const::South_america_countries,:name => 'Megafon, South America'}
rln << {:id => 10105, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => Category::Country::Const::Afrika, :children => Category::Country::Const::Africa_countries,:name => 'Megafon, Africa'}
rln << {:id => 10106, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => Category::Country::Mts::Sic_countries,:name => 'Megafon, CIS'}


rln << {:id => 20000, :type_id => _main_operator_by_country, :owner_id => Category::Country::Const::Ukraina, :parent_id => nil, :children => [Category::Operator::Const::MtsUkrain],:name => ''}
rln << {:id => 20001, :type_id => _main_operator_by_country, :owner_id => Category::Country::Const::Russia, :parent_id => nil, :children => [Category::Operator::Const::Tele2, Category::Operator::Const::Mts, Category::Operator::Const::Beeline, Category::Operator::Const::Megafon],:name => ''}

i = 3003;; j = 20002
ctr = []; rln = []
Category.where(:id => Category::Country::Const::World_countries_without_russia).each do |country|
  ctr << {:id => i, :type_id => 2, :level_id => nil, :parent_id => Category::Operator::Const::Foreign_operators, :name => "operator_in_#{country.slug}"}
  rln << {:id => j, :type_id => _main_operator_by_country, :owner_id => country.id, :parent_id => nil, :children => [i], :name => ''}
  i += 1; j += 1
end

Relation.transaction do
  Category.create(ctr)
  Relation.create(rln)
end
