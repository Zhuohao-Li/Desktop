function data_out=frame_gen(rate, ml, data)

Ndbps=48*ml*rate;
Nsym=ceil((16+length(data)+6)/Ndbps);
Ndata=Nsym*Ndbps;
Npad=Ndata-(16+length(data)+6);
data_out=zeros(1,Ndata);
data_out(1,17:(Ndata-Npad-6))=data;

end