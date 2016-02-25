module EventsHelper
  def cities
    ["Alaminos", "Angeles", "Antipolo", "Bacolod", "Bacoor", "Bago", "Baguio", "Bais", "Balanga", "Batac", "Batangas ", "Bayawan", "Baybay", "Bayugan", "Biñan", "Bislig", "Bogo", "Borongan", "Butuan", "Cabadbaran", "Cabanatuan", "Cabuyao", "Cadiz", "Cagayan de Oro", "Calamba", "Calapan", "Calbayog", "Caloocan", "Candon", "Canlaon", "Carcar", "Catbalogan", "Cauayan", "Cavite", "Cebu", "Cotabato ", "Dagupan", "Danao", "Dapitan", "Dasmariñas", "Davao", "Digos", "Dipolog", "Dumaguete", "El Salvador", "Escalante", "Gapan", "General Santos", "General Trias", "Gingoog", "Guihulngan", "Himamaylan", "Ilagan", "Iligan", "Iloilo ", "Imus", "Iriga", "Isabela", "Kabankalan", "Kidapawan", "Koronadal", "La Carlota", "Lamitan", "Laoag", "Lapu-Lapu", "Las Piñas", "Legazpi", "Ligao", "Lipa", "Lucena", "Maasin", "Mabalacat", "Makati", "Malabon", "Malaybalay", "Malolos", "Mandaluyong", "Mandaue", "Manila", "Marawi", "Marikina", "Masbate ", "Mati", "Meycauayan", "Muñoz", "Muntinlupa", "Naga", "Naga", "Navotas", "Olongapo", "Ormoc", "Oroquieta", "Ozamiz", "Pagadian", "Palayan", "Panabo", "Parañaque", "Pasay", "Pasig", "Passi", "Puerto Princesa", "Quezon ", "Roxas", "Sagay", "Samal", "San Carlos", "San Carlos", "San Fernando", "San Fernando", "San Jose", "San Jose del Monte", "San Juan", "San Pablo", "San Pedro", "Santa Rosa", "Santiago", "Silay", "Sipalay", "Sorsogon ", "Surigao ", "Tabaco", "Tabuk", "Tacloban", "Tacurong", "Tagaytay", "Tagbilaran", "Taguig", "Tagum", "Talisay", "Talisay", "Tanauan", "Tandag", "Tangub", "Tanjay", "Tarlac ", "Tayabas", "Toledo", "Trece Martires", "Tuguegarao", "Urdaneta", "Valencia", "Valenzuela", "Victorias", "Vigan", "Zamboanga"]
  end

  def provinces
    ["Abra","Agusan del Norte","Agusan del Sur","Aklan","Albay","Antique","Apayao","Aurora","Basilan","Bataan","Batanes","Batangas","Benguet","Biliran","Bohol","Bukidnon","Bulacan","Cagayan","Camarines Norte","Camarines Sur","Camiguin","Capiz","Catanduanes","Cavite","Cebu","Compostela Valley","Cotabato","Davao del Norte","Davao del Sur","Davao Occidental","Davao Oriental","Dinagat Islands","Eastern Samar","Guimaras","Ifugao","Ilocos Norte","Ilocos Sur","Iloilo","Isabela","Kalinga","La Union","Laguna","Lanao del Norte","Lanao del Sur","Leyte","Maguindanao","Marinduque","Masbate","Metro Manila","Misamis Occidental","Misamis Oriental","Mountain Province","Negros Occidental","Negros Oriental","Northern Samar","Nueva Ecija","Nueva Vizcaya","Occidental Mindoro","Oriental Mindoro","Palawan","Pampanga","Pangasinan","Quezon","Quirino","Rizal","Romblon","Samar","Sarangani","Siquijor","Sorsogon","South Cotabato","Southern Leyte","Sultan Kudarat","Sulu","Surigao del Norte","Surigao del Sur","Tarlac","Tawi-Tawi","Zambales","Zamboanga del Norte","Zamboanga del Sur","Zamboanga Sibugay"]
  end

  def start_dates
    start_dates = []
    if current_user.try(:admin?)
      Event.uniq.pluck(:start_date).each do |start_date|
        #start_dates.push(to_char(start_date,'YYYY-MM-DD'))
        start_dates.push(start_date.strftime('%Y-%m-%d'))
      end
    else
      Event.where(status: "Approved").uniq.pluck(:start_date).each do |start_date|
        #start_dates.push(to_char(start_date,'YYYY-MM-DD'))
        start_dates.push(start_date.strftime('%Y-%m-%d'))
      end
    end
    return start_dates
  end
end
