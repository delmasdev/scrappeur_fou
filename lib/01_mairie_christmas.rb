require 'nokogiri' #gem de nokogiri.
require 'open-uri' #gem de nokogiri pour utiliser un lien internet.

#méthode pour rechercher les noms des villes des mairies.
def mairie_names

  #ouvre l'URL souhaitée sous Nokogiri et stocke dans un objet 'page'. Ici le site de l'annuaire des mairies du val d'oise.
  page = Nokogiri::HTML(open("https://annuaire-des-mairies.com/val-d-oise.html"))

  #lie le xpath avec le tableau des noms.
  names = page.xpath('//a[@class="lientxt"]')

  array = mairie_scraper(page, names)
end


#méthode pour rechercher les emails des mairies.
def mairie_mail(names, x)

  lien = names[x]['href'].gsub(/^[\.]/, '') #permet de récupérer le lien vers les emails grâce au 'HREF', mais penser à enlever le "point" devant.
  page = Nokogiri::HTML(open("https://annuaire-des-mairies.com/#{lien}"))
  email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
end


#méthode qui créée un tableau contenant plusieurs 'hash'.
def mairie_scraper(page, names)

  array = []

  #pour chaque ville, nous mettons son nom et son email dans le tableau.
  (0..names.length-1).each { |x|
    new_hash = {}
    mairie = names[x].text.downcase.gsub(/[\s]/, '_') #pour mettre en minuscule et remplacer les espaces par des underscores.
    new_hash[mairie] = mairie_mail(names, x)
    array << new_hash

    #affiche dans le terminal si besoin.
    puts array
  }

   return array
end

mairie_names
