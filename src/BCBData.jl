
# Check if curl is installed
try
	print("Checking for curl...")
	cmd = `curl --version`
	(VERSION >= v"0.5")? readstring(cmd) : readall(`curl --version`)
	println("OK!")
catch
	error("Curl not found. Please install curl to use BCBData.")
end

module BCBData

	using Base.Dates
	
	export ProxyConfig,
			readData
	
	type ProxyConfig
		host::String
		port::Int64
		user::String
		password::String
		
		function ProxyConfig() 
			new("", 80, "", "") 
		end #function
		function ProxyConfig(	host::String, port::Int64, user::String, password::String)
			new(host, port, user, password)
		end #function
	end # type
	
	function readData(code::Int64, startDate::Date, endDate::Date, proxy=ProxyConfig())
	
		str_start = Dates.format(startDate, "dd/mm/yyyy")
		str_end = Dates.format(endDate, "dd/mm/yyyy")
		
		if(proxy.host == "")
			str_proxy = ""
		else
			host = 
			str_proxy = `--proxy $(proxy.host):$(proxy.port) --proxy-user $(proxy.user):$(proxy.password)`
		end #if
		
		cmd = `curl -s -S --header "SOAPAction:\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br#getValoresSeriesXML\"" --header "Accept: text/xml" --header "Accept: multipart/*" --header "Content-Type: text/xml; charset=utf-8" --header "SOAPAction: \"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br#getValoresSeriesXML\"" -d "<?xml version=\"1.0\"?><SOAP-ENV:Envelope xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">  <SOAP-ENV:Body>    <getValoresSeriesXML xmlns=\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br\">      <in0 xsi:type=\"SOAP-ENC:Array\" SOAP-ENC:arrayType=\"NA[1]\">        <item>$code</item>      </in0>      <in1 xsi:type=\"xsd:string\">$str_start</in1>      <in2 xsi:type=\"xsd:string\">$str_end</in2>    </getValoresSeriesXML>  </SOAP-ENV:Body></SOAP-ENV:Envelope>" $str_proxy https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS`
		
		
		response = (VERSION >= v"0.5")? readstring(cmd) : readall(cmd)
		
		str_dates = String[]
		str_values = Float64[]
		
		pattern = r"DATA&gt;(.*?)&lt;/DATA&gt;\n\t\t\t&lt;VALOR&gt;(.*?)&"
		
		for m in eachmatch(pattern, response)
			push!(str_dates, m.captures[1])
			push!(str_values, parse(Float64, m.captures[2]))
		end #for
	
		return(str_dates, str_values)
		
	end #function

	
end #module


