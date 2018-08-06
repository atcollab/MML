function fun=faisceau(nbpixelsx,nbpixelsy,sigmax,sigmay,centrex,centrey,pourc)


Y=(meshgrid(1:nbpixelsx+1,1:nbpixelsy+1))';
%Y=(1:nbpixelsy+1)';
X=meshgrid(1:nbpixelsy+1,1:nbpixelsx+1);
%X=(1:nbpixelsx+1)';
p=pourc*0.01;
sigx=1*((1-p)*sigmax+2*p*sigmax*rand(1));
sigy=1*((1-p)*sigmay+2*p*sigmay*rand(1));
cx=1*((1-p)*centrex+2*p*centrex*rand(1));
cy=1*((1-p)*centrey+2*p*centrey*rand(1));

a=bigauss_bruit(X,Y,sigx,sigy,cx,cy,pourc/4);
% on enleve le bruit de bigauss car redondant
%a=bigauss(X,Y,sigx,sigy,cx,cy);

%s=1*((1-pourc)*se+2*pourc*se.*rand(1,length(se)));

b = p*rand(nbpixelsx+1,nbpixelsy+1);

		% % pixels morts
		% n=size(a);
		% d=gallery('rando',n,1);
		% 
		% for i=1:10
		%     c(i,:,:)=gallery('rando',n,1);
		%     d=d.*squeeze(c(i,:,:));
		% end
%fun=a+b+d;

fun=a+b;
%fun=a;
% figure(4)
% 
 %image(a+b+d,'CDataMapping','scaled')
%image(fun,'CDataMapping','scaled')
