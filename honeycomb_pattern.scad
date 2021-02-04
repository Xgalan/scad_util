module honeycomb(a, xdim, ydim){

	echo (str("Empfehle für die aktuelle Vorgabe des Hexagon-Durchmessers ein vielfaches von ", (a[0]/2 - a[1]/4  + a[0] - a[1]/2 )/2, " für xdim", " und ein vielfaches von ",  h1 - (h1-h0)/2, " für ydim"));
	echo (str ("xdim ist ",xdim));
	echo (str ("ydim ist ",ydim));
	echo ("Dadurch ergäbe sich ein homogenes Wabenmuster ohne seltsame Abweichungen an den Rändern.");
	echo("");
	echo (str("best dimension in x and y is a multiple of ", (a[0]/2 - a[1]/4  + a[0] - a[1]/2 )/2, " for xdim", " and a multiple of  ",  h1 - (h1-h0)/2, " for ydim to get a nice-looking honeycomb pattern for your selected diameter setting."));
	
	module hex(a){
		difference(){
			circle(d=a[0], $fn=6);
			circle(d=a[0]-a[1], $fn=6);
		}
	}
	
	h0 = a[0]/4 * sqrt(3);
	h1 = (a[0]-a[1])/4 * sqrt(3); 
	
	intersection()
	{
		for (j = [0:ydim/(a[0]-a[1])+1]) {
			translate([0,( 2*h0  - (h0-h1) ) * j ,0])			
			for(i = [0:xdim*0.075]){
				translate([  i * ( a[0]/2 - a[1]/4  + a[0] - a[1]/2   )  ,0,0])hex(a);
				translate([  ( a[0]/4 -a[1]/8 + (a[0]-a[1]/2)/2 ) +  i * ( a[0]/2 - a[1]/4  + a[0] - a[1]/2  ) ,(2*h0  - (h0-h1))/2,0])hex(a);
			}
		}
		square([xdim,ydim]);
	}	
}

honeycomb([10,2],6.75 * 5 ,3.89711*9);

