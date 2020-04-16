require 'nokogiri' #gem de nokogiri.
require 'open-uri' #gem de nokogiri pour utiliser un lien internet.

#méthode pour rechercher les noms et valeurs des cryptos.
def crypto_names_prices

  #ouvre l'URL souhaitée sous Nokogiri et stocke dans un objet 'page'.
  page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))

  #lie le xpath avec nos tableaux.
  names = page.xpath('//div[@class="cmc-table__table-wrapper-outer"]/div/table/tbody/tr[@class="cmc-table-row"]/td[contains(@class, "symbol")]')
  prices = page.xpath('//div[@class="cmc-table__table-wrapper-outer"]/div/table/tbody/tr[@class="cmc-table-row"]/td[contains(@class, "price")]')

  array_crypto = crypto_scraper(names, prices)
end


#méthode qui créée un tableau contenant plusieurs 'hash'.
def crypto_scraper(names, prices)

  array = []

  #pour chaque crypto, nous mettons son nom et valeur dans le tableau.
  for x in 0..names.length-1 do
    array[x] = Hash.new
    array[x][names[x].text]= prices[x].text.gsub(/[^\d\.]/, '') #pour enlever le signe $, remplacer le premier charactère devant le digit par rien.
  end

  #affiche dans le terminal si besoin.
  puts array

  return array
end

crypto_names_prices
