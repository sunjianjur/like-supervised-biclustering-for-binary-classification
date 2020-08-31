function row=chazhao(Zsmall,value)
row=[];
for i=1:size(Zsmall,1)

        if Zsmall(i,1)==value
           row=i;
           break;
        end

end

end