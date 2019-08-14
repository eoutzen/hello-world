//Meta

	*What: Do-file for VAR analysis as in Iacoviello 2005 with open economy features
	*Date created: 6/4 2018
	*Last modified: 7/4 2018
	
// Load data	

clear all

use "/Users/emiloutzen/OneDrive - Aarhus universitet/Ba_oecon/Data/VAR_6/VAR_ver6.dta"

//VAR


	
	//VAR with indskud

	varsoc lngdp_real_hp dlncpi lndk_real3_hp indskud lnex, maxlag(10) exog(trend eu_lending)
	varsoc lngdp_real_hp dlncpi lndk_real3_hp indskud, maxlag(10) exog(eu_lending)
	varsoc lngdp_real dlncpi lndk_korr3 indskud if time >= yq(1997,1), maxlag(10) exog(eu_lending)
	varsoc lngdp_real dlncpi lndk_korr3 indskud, maxlag(10)
	varsoc lngdp_real_hp dlncpi lndk_real3_hp indskud if time >= yq(1994,1), maxlag(5) exog(eu_lending)
	varsoc lngdp_real_hp dlncpi lndk_real3_hp indskud lnex if time >= yq(1997,1), maxlag(5) exog(eu_lending)
		*BIC:2
	
	varsoc lngdp_real_hp dlncpi lndk_real3_hp indskud, maxlag(10) exog(eu_lending dumPreEuro)
		*BIC: 2
	
	*lag specification
	
			
	//Order 2* (1994)
	var lngdp_real_hp dlncpi lndk_real3_hp indskud lnex if time >= yq(1994,1), lags(1/2) exog(eu_lending)
		*test
		varstable
			*stable
		predict res, residuals
		wntestq res, lags(40)
		drop res
			*autocorr all: none (.60)
		varlmar, mlag(10)
			*autocorr: 1, 8
		varnorm
			*rejected for JB, K
		vargranger
	
	//Order 2* (1997)
	var lngdp_real_hp dlncpi lndk_real3_hp indskud lnex if time >= yq(1997,1), lags(1/3) exog(eu_lending)
	var indskud lnex lngdp_real_hp dlncpi lndk_real3_hp if time >= yq(1997,1), lags(1/2) exog(trend eu_lending)
		*test
		varstable
			*stable
		predict res, residuals
		wntestq res, lags(40)
		drop res
			*autocorr all: none (.60)
		varlmar, mlag(10)
			*autocorr: 8
		varnorm
			*rejected for JB, K
		vargranger
		
	//Order 2* (1999)
	var lngdp_real_hp dlncpi lndk_real3_hp indskud lnex if time >= yq(1999,1), lags(1/2) exog(trend eu_lending)
		*test
		varstable
			*stable
		predict res, residuals
		wntestq res
		drop res
			*autocorr all: not rejected (.72)
		varnorm
			*Rejected: JB, K
		
	
	
	//Order 3, 1997
	var lngdp_real_hp dlncpi lndk_real3_hp indskud lnex if time >= yq(1997,1), lags(1/3) exog(trend eu_lending)
	var lngdp_real_hp dlncpi lndk_real3_hp indskud, lags(1/3) exog(eu_lending)
	var lngdp_real dlncpi lndk_korr3 indskud if time >= yq(1997,1), lags(1/3) exog(eu_lending)
	var lngdp_real dlncpi lndk_korr3 indskud if time >= yq(1997,1), lags(1/3)
	var lngdp_real_hp dlncpi lndk_real3_hp indskud, lags(1/3) exog(eu_lending dumPreEuro trend)
		*test
		varstable
			*stable
		predict res, residuals
		wntestq res
		drop res
			*autocorr all: not rejected (.23)
		varlmar, mlag(10)
			*autocorr: collinearity
		varnorm
			*Rejected: none
		vargranger
		
			
	//Order 4
	var lngdp_real_hp dslncpi lndk_real_hp indskud lnex if time >= yq(1997,1), lags(1/4) exog(trend eu_lending)
	var lngdp_real dlncpi lndk_korr3 indskud if time >= yq(1997,1), lags(1/3) exog(eu_lending)
		*test
		varstable
			*stable
		predict res, residuals
		wntestq res, lags(40)
		drop res
			*autocorr all: rejected (20, 30, 40 lags)
		varnorm
			

//IRF w/ indskud

			irf drop order1
			irf drop order2
						
			graph drop _all
			
		*Generate IRF
	
		irf create order1, step(20) set(myirf1)
		irf create order2, step(20) set(myirf1) bsp reps(1000)
		
	
	
	
	//Shock to R
		
	*OIRF: graph - order1
		
		irf graph oirf, level(90) impulse(indskud) response(lngdp_real_hp) name(irf_Dr_Dy90) nodraw
		irf graph oirf, level(90) impulse(indskud) response(lndk_real3_hp) name(irf_Dr_Dhus90) nodraw 
		irf table oirf, level(90) impulse(indskud) response(lndk_real3_hp)
		irf graph oirf, level(90) impulse(indskud) response(indskud) name(irf_Dr_Di90) nodraw
		irf graph oirf, level(90) impulse(indskud) response(dlncpi) name(irf_Dr_Dp90) nodraw
		//irf graph oirf, level(90) impulse(indskud) response(lnex) name(irf_Dr_Dex90) nodraw
		
		graph combine irf_Dr_Dy90 irf_Dr_Dhus90 irf_Dr_Di90 irf_Dr_Dp90, row(2) col(3) colfirst name(graphIRF_r_90)
		
		irf_Dr_Dex90
		
		//Comment
			*Order 2: lnex decreases (insig), cpi decreases.
			
	
		
	
	//Shock to Y
			
	*OIRF: graph
		
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(lngdp_real_hp) name(irf_Dy_Dy90) nodraw
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(lndk_real3_hp) name(irf_Dy_Dhus90) nodraw 
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(indskud) name(irf_Dy_Di90) nodraw
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(dlncpi) name(irf_Dy_Dp90) nodraw
		//irf graph oirf, impulse(lngdp_real_hp) level(90) response(lnex) name(irf_Dy_Dex90) nodraw
		
		graph combine irf_Dy_Dy90 irf_Dy_Dhus90 irf_Dy_Di90 irf_Dy_Dp90 , row(2) col(3) colfirst name(graphIRF_y_90)
		
		irf_Dy_Dex90
		
		//Comment
			*order 2: CPI increase significantly. HP also increase, but insignificantly.
	
	//Shock to HP
	*OIRF: graph
		
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(lngdp_real_hp) name(irf_Dhus_Dy90) nodraw
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(lndk_real3_hp) name(irf_Dhus_Dhus90) nodraw 
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(indskud) name(irf_Dhus_Di90) nodraw
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(dlncpi) name(irf_Dhus_Dp90) nodraw
		//irf graph oirf, impulse(lndk_real3_hp) level(90) response(lnex) name(irf_Dhus_Dex90) nodraw
		
		graph combine irf_Dhus_Dy90 irf_Dhus_Dhus90 irf_Dhus_Di90 irf_Dhus_Dp90, row(2) col(3) colfirst name(graphIRF_hus_90)
	
		irf_Dhus_Dex90
	
		//comment
			*order 2: clear increase in gdp. lnex decrease significantly. CPI and indskud increases but insignificantly.
	
	//Shock to CPI
		
	*OIRF: cpi (dlncpi)
		
		irf graph oirf, impulse(dlncpi) level(90) response(lngdp_real_hp) name(irf_Dp_Dy90) nodraw
		irf graph oirf, impulse(dlncpi) level(90) response(lndk_real3_hp) name(irf_Dp_Dhus90) nodraw 
		irf graph oirf, impulse(dlncpi) level(90) response(indskud) name(irf_Dp_Di90) nodraw
		irf graph oirf, impulse(dlncpi) level(90) response(dlncpi) name(irf_Dp_Dp90) nodraw
		//irf graph oirf, impulse(dlncpi) level(90) response(lnex) name(irf_Dp_Dex90) nodraw
		
	
		graph combine irf_Dp_Dy90 irf_Dp_Dhus90 irf_Dp_Di90 irf_Dp_Dp90, row(2) col(3) colfirst name(graphIRF_p_90)
		
		irf_Dp_Dex90
		
		//comment
			*order 2: Significant increase in folio. hereafter significant drops in gdp and HP.

	//Shock to E
		
	*OIRF: graph - order 1
		
		irf graph oirf, impulse(lnex) level(90) response(lngdp_real_hp) name(irf_De_Dy90) nodraw
		irf graph oirf, impulse(lnex) level(90) response(lndk_real3_hp) name(irf_De_Dhus90) nodraw 
		irf graph oirf, impulse(lnex) level(90) response(indskud) name(irf_De_Di90) nodraw
		irf graph oirf, impulse(lnex) level(90) response(dlncpi) name(irf_De_Dp90) nodraw
		irf graph oirf, impulse(lnex) level(90) response(lnex) name(irf_De_Dex90) nodraw
		
		graph combine irf_De_Dy90 irf_De_Dhus90 irf_De_Di90 irf_De_Dp90 irf_De_Dex90, row(2) col(3) colfirst name(graphIRF_e_90)
			
			//comment
				*order 2: indskud increases and cpi decreases. GDP and HP has no clear effect.
	
		
	//Shock to EU
	
		irf graph dm, impulse(eu_lending) level(90) response(lngdp_real_hp) name(irf_Deu_Dy90) nodraw
		irf graph dm, impulse(eu_lending) level(90) response(lndk_real3_hp) name(irf_Deu_Dhus90) nodraw 
		irf graph dm, impulse(eu_lending) level(90) response(indskud) name(irf_Deu_Di90) nodraw
		irf graph dm, impulse(eu_lending) level(90) response(dlncpi) name(irf_Deu_Dp90) nodraw
		//irf graph dm, impulse(eu_lending) level(90) response(lnex) name(irf_Deu_Dex90) nodraw
		
		graph combine irf_Deu_Dy90 irf_Deu_Dhus90 irf_Deu_Di90 irf_Deu_Dp90, row(2) col(3) colfirst name(graphIRF_eu_90)
			
		irf_Deu_Dex90	

			
	*all
	graph combine irf_Dr_Dy90 irf_Dr_Dhus90 irf_Dr_Di90 irf_Dr_Dp90 irf_Dr_Dex90 irf_Dy_Dy90 irf_Dy_Dhus90 irf_Dy_Di90 irf_Dy_Dp90 irf_Dy_Dex90 irf_Dhus_Dy90 irf_Dhus_Dhus90 irf_Dhus_Di90 irf_Dhus_Dp90 irf_Dhus_Dex90  irf_Dp_Dy90 irf_Dp_Dhus90 irf_Dp_Di90 irf_Dp_Dp90 irf_Dp_Dex90 irf_De_Dy90 irf_De_Dhus90 irf_De_Di90 irf_De_Dp90 irf_De_Dex90, row(5) col(5) colfirst

	
	
// Levels

	//Shock to R
		
	*OIRF: graph - order1
		
		irf graph oirf, level(90) impulse(indskud) response(lngdp_real) name(irf_Dr_Dy90) nodraw
		irf graph oirf, level(90) impulse(indskud) response(lndk_korr3) name(irf_Dr_Dhus90) nodraw 
		irf graph oirf, level(90) impulse(indskud) response(indskud) name(irf_Dr_Di90) nodraw
		irf graph oirf, level(90) impulse(indskud) response(dlncpi) name(irf_Dr_Dp90) nodraw
		//irf graph oirf, level(90) impulse(indskud) response(lnex) name(irf_Dr_Dex90) nodraw
		
		graph combine irf_Dr_Dy90 irf_Dr_Dhus90 irf_Dr_Di90 irf_Dr_Dp90, row(2) col(3) colfirst name(graphIRF_r_90)
		
		//Comment
			*Order 2: lnex decreases (insig), cpi decreases.
			
	
		
	
	//Shock to Y
			
	*OIRF: graph
		
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(lngdp_real_hp) name(irf_Dy_Dy90) nodraw
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(lndk_real3_hp) name(irf_Dy_Dhus90) nodraw 
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(indskud) name(irf_Dy_Di90) nodraw
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(dlncpi) name(irf_Dy_Dp90) nodraw
		irf graph oirf, impulse(lngdp_real_hp) level(90) response(lnex) name(irf_Dy_Dex90) nodraw
		
		graph combine irf_Dy_Dy90 irf_Dy_Dhus90 irf_Dy_Di90 irf_Dy_Dp90 irf_Dy_Dex90, row(2) col(3) colfirst name(graphIRF_y_90)
		
		//Comment
			*order 2: CPI increase significantly. HP also increase, but insignificantly.
	
	//Shock to HP
	*OIRF: graph
		
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(lngdp_real_hp) name(irf_Dhus_Dy90) nodraw
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(lndk_real3_hp) name(irf_Dhus_Dhus90) nodraw 
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(indskud) name(irf_Dhus_Di90) nodraw
		irf graph oirf, impulse(lndk_real3_hp) level(90) response(dlncpi) name(irf_Dhus_Dp90) nodraw
		//irf graph oirf, impulse(lndk_real3_hp) level(90) response(lnex) name(irf_Dhus_Dex90) nodraw
		
		graph combine irf_Dhus_Dy90 irf_Dhus_Dhus90 irf_Dhus_Di90 irf_Dhus_Dp90, row(2) col(3) colfirst name(graphIRF_hus_90)
	
		irf_Dhus_Dex90
	
		//comment
			*order 2: clear increase in gdp. lnex decrease significantly. CPI and indskud increases but insignificantly.
	
	//Shock to CPI
		
	*OIRF: cpi (dlncpi)
		
		irf graph oirf, impulse(dlncpi) level(90) response(lngdp_real_hp) name(irf_Dp_Dy90) nodraw
		irf graph oirf, impulse(dlncpi) level(90) response(lndk_real3_hp) name(irf_Dp_Dhus90) nodraw 
		irf graph oirf, impulse(dlncpi) level(90) response(indskud) name(irf_Dp_Di90) nodraw
		irf graph oirf, impulse(dlncpi) level(90) response(dlncpi) name(irf_Dp_Dp90) nodraw
		irf graph oirf, impulse(dlncpi) level(90) response(lnex) name(irf_Dp_Dex90) nodraw
		
	
		graph combine irf_Dp_Dy90 irf_Dp_Dhus90 irf_Dp_Di90 irf_Dp_Dp90 irf_Dp_Dex90, row(2) col(3) colfirst name(graphIRF_p_90)
		
		//comment
			*order 2: Significant increase in folio. hereafter significant drops in gdp and HP.

	//Shock to E
		
	*OIRF: graph - order 1
		
		irf graph oirf, impulse(lnex) level(90) response(lngdp_real_hp) name(irf_De_Dy90) nodraw
		irf graph oirf, impulse(lnex) level(90) response(lndk_real3_hp) name(irf_De_Dhus90) nodraw 
		irf graph oirf, impulse(lnex) level(90) response(indskud) name(irf_De_Di90) nodraw
		irf graph oirf, impulse(lnex) level(90) response(dlncpi) name(irf_De_Dp90) nodraw
		irf graph oirf, impulse(lnex) level(90) response(lnex) name(irf_De_Dex90) nodraw
		
		graph combine irf_De_Dy90 irf_De_Dhus90 irf_De_Di90 irf_De_Dp90 irf_De_Dex90, row(2) col(3) colfirst name(graphIRF_e_90)
			
			//comment
				*order 2: indskud increases and cpi decreases. GDP and HP has no clear effect.
	
		
	//Shock to EU
	
		irf graph dm, impulse(eu_lending) level(90) response(lngdp_real_hp) name(irf_Deu_Dy90) nodraw
		irf graph dm, impulse(eu_lending) level(90) response(lndk_real3_hp) name(irf_Deu_Dhus90) nodraw 
		irf graph dm, impulse(eu_lending) level(90) response(indskud) name(irf_Deu_Di90) nodraw
		irf graph dm, impulse(eu_lending) level(90) response(dlncpi) name(irf_Deu_Dp90) nodraw
		//irf graph dm, impulse(eu_lending) level(90) response(lnex) name(irf_Deu_Dex90) nodraw
		
		graph combine irf_Deu_Dy90 irf_Deu_Dhus90 irf_Deu_Di90 irf_Deu_Dp90, row(2) col(3) colfirst name(graphIRF_eu_90)
			
		irf_Deu_Dex90	

			
	*all
	graph combine irf_Dr_Dy90 irf_Dr_Dhus90 irf_Dr_Di90 irf_Dr_Dp90 irf_Dr_Dex90 irf_Dy_Dy90 irf_Dy_Dhus90 irf_Dy_Di90 irf_Dy_Dp90 irf_Dy_Dex90 irf_Dhus_Dy90 irf_Dhus_Dhus90 irf_Dhus_Di90 irf_Dhus_Dp90 irf_Dhus_Dex90  irf_Dp_Dy90 irf_Dp_Dhus90 irf_Dp_Di90 irf_Dp_Dp90 irf_Dp_Dex90 irf_De_Dy90 irf_De_Dhus90 irf_De_Di90 irf_De_Dp90 irf_De_Dex90, row(5) col(5) colfirst
