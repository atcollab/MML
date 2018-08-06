function b = dacquantization(a, q)


b = a + sign(a) .* q/2 - rem( a+sign(a).*q/2 , q );