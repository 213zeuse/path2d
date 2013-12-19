--computing the length of any picewise polynomial curve using the Gauss quadrature.
--taken from http://processingjs.nihongoresources.com/bezierinfo/

local hypot = require'path_point'.hypot

local abs = math.abs

--Legendre-Gauss abscissae for 24 steps.
--xi values, defined at i=n as the roots of the nth order Legendre polynomial Pn(x).
local abscissae = {
	-0.0640568928626056299791002857091370970011,
	 0.0640568928626056299791002857091370970011,
	-0.1911188674736163106704367464772076345980,
	 0.1911188674736163106704367464772076345980,
	-0.3150426796961633968408023065421730279922,
	 0.3150426796961633968408023065421730279922,
	-0.4337935076260451272567308933503227308393,
	 0.4337935076260451272567308933503227308393,
	-0.5454214713888395626995020393223967403173,
	 0.5454214713888395626995020393223967403173,
	-0.6480936519369755455244330732966773211956,
	 0.6480936519369755455244330732966773211956,
	-0.7401241915785543579175964623573236167431,
	 0.7401241915785543579175964623573236167431,
	-0.8200019859739029470802051946520805358887,
	 0.8200019859739029470802051946520805358887,
	-0.8864155270044010714869386902137193828821,
	 0.8864155270044010714869386902137193828821,
	-0.9382745520027327978951348086411599069834,
	 0.9382745520027327978951348086411599069834,
	-0.9747285559713094738043537290650419890881,
	 0.9747285559713094738043537290650419890881,
	-0.9951872199970213106468008845695294439793,
	 0.9951872199970213106468008845695294439793}

--Legendre-Gauss weights for 24 steps.
--wi values, defined by a function linked to in the Bezier primer article.
local weights = {
	0.1279381953467521593204025975865079089999,
	0.1279381953467521593204025975865079089999,
	0.1258374563468283025002847352880053222179,
	0.1258374563468283025002847352880053222179,
	0.1216704729278033914052770114722079597414,
	0.1216704729278033914052770114722079597414,
	0.1155056680537255991980671865348995197564,
	0.1155056680537255991980671865348995197564,
	0.1074442701159656343712356374453520402312,
	0.1074442701159656343712356374453520402312,
	0.0976186521041138843823858906034729443491,
	0.0976186521041138843823858906034729443491,
	0.0861901615319532743431096832864568568766,
	0.0861901615319532743431096832864568568766,
	0.0733464814110802998392557583429152145982,
	0.0733464814110802998392557583429152145982,
	0.0592985849154367833380163688161701429635,
	0.0592985849154367833380163688161701429635,
	0.0442774388174198077483545432642131345347,
	0.0442774388174198077483545432642131345347,
	0.0285313886289336633705904233693217975087,
	0.0285313886289336633705904233693217975087,
	0.0123412297999872001830201639904771582223,
	0.0123412297999872001830201639904771582223}

--return a function that computes the length of a quad or cubic curve at parameter t, given the formulas
--for extracting coefficients and for computing the first derivative based on the coefficients.
local function length_function(coefficients, derivative1_for)
	return function(t, x1, y1, x2, y2, x3, y3, x4, y4)
		local ax, bx, cx = coefficients(x1, x2, x3, x4)
		local ay, by, cy = coefficients(y1, y2, y3, y4)
		local z2 = t / 2
		local sum = 0
		for i=1,#abscissae do
			local corrected_t = z2 * abscissae[i] + z2
			local dx = derivative1_for(corrected_t, ax, bx, cx)
			local dy = derivative1_for(corrected_t, ay, by, cy)
			sum = sum + weights[i] * hypot(dx, dy)
		end
		return z2 * sum
	end
end

if not ... then require'path_hit_demo' end

return length_function

