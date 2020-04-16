require 'nokogiri' #gem de nokogiri.
require 'open-uri' #gem de nokogiri pour utiliser un lien internet.

#méthode pour rechercher les noms des députés.
def depute_names

  #ouvre l'URL souhaitée sous Nokogiri et stocke dans un objet 'page'. Ici le site de l'assemblée nationale.
  page = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))

  #lie le xpath avec le tableau des noms.
  names = page.xpath('//div[@id="deputes-list"]/div/ul/li/a')

  array = depute_scraper(page, names)
end


#méthode pour rechercher les emails des députés.
def depute_mail(names, x)

  lien = names[x]['href'] #permet de récupérer le lien vers les emails grâce au 'HREF'.
  page = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr#{lien}"))
  email = page.xpath('//*[@class="deputes-liste-attributs"]/dd[4]/ul/li[2]/a').text
end


#méthode qui créée un tableau contenant plusieurs 'hash'.
def depute_scraper(page, names)

  array = []

  #pour chaque député, nous mettons son nom et son email dans le tableau.
  (0..names.length-1).each { |x|
    new_hash = {}
    depute = names[x].text.gsub(/^([M][\.][\s])|^([M][m][e])[\s]/, '').split(' ', 2) #pour supp. M. et Mme, et séparer le tableau en 2 au niveau des espaces.
    new_hash["first_name"] = depute[0] #hash pour le prénom.
    new_hash["last_name"] = depute[1] #hash pour le nom.
    new_hash["email"] = depute_mail(names, x) #hash pour l'email.
    array << new_hash

    #affiche dans le terminal si besoin.
    puts array
  }

   return array
end

depute_names
