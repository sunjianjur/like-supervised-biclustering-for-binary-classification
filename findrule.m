function [rule]=findrule(data,delta,label,confidence)

rule=[];

[nr,nc]=size(data);
entropy=ENT(data);
r=1:nr;
c=1:nc;

%delete multiple row/column
deltacombine=[1000000 entropy];
while((entropy>delta)&&deltacombine(end-1)>deltacombine(end))
    alpha=entropy/delta;
    ER=[];
    for i=1:length(r)
        tempr=setdiff(r,r(i));
         ER=[ER ENT(data(tempr,c))];
    end    
    ER=entropy-ER;
    bigrpos=find(ER>entropy*alpha);
    r=setdiff(r,r(bigrpos));
    
    entropy=ENT(data(r,c));
    alpha=entropy/delta;
    
    EC=[];
    for i=1:length(c)
       EC=[EC ENT(data(r,setdiff(c,c(i))))];
    end
    EC=entropy-EC;
    bigcpos=find(EC>entropy*alpha);
    c=setdiff(c,c(bigcpos));
    entropy=ENT(data(r,c));
    
    deltacombine=[deltacombine entropy];
end

%delete single row/column
deltacombine=[10000000 entropy];
while((entropy>delta)&&deltacombine(end-1)>deltacombine(end))
     ER=[];
    for i=1:length(r)
        tempr=setdiff(r,r(i));
         ER=[ER ENT(data(tempr,c))];
    end    
    [minre,minrpos]=min(ER);

    EC=[];
    for i=1:length(c)
       EC=[EC ENT(data(r,setdiff(c,c(i))))];
    end
    [mince,mincpos]=min(EC);

    if minre<mince
        r=setdiff(r,r(minrpos));
    else
        c=setdiff(c,c(mincpos));
    end

    entropy=ENT(data(r,c));
end

%add row/column
wholer=1:nr;wholec=1:nc;
remainr=setdiff(wholer,r);
remainc=setdiff(wholec,c);
tiji=[0; sum(r)+sum(c)];
while(entropy<delta)&&(tiji(end,:)>tiji(end-1,:))
    ER=[];
    for i=1:length(remainr)
       tempr=[r remainr(i)];
       ER=[ER ENT(data(tempr,c))];
    end
    r=[r remainr(find(ER<=entropy))];
    remainr=setdiff(wholer,r);
    entropy=ENT(data(r,c));
    
     EC=[];
    for i=1:length(remainc)
       tempc=[c remainc(i)];
       EC=[EC ENT(data(r,tempc))];
    end
    c=[c remainc(find(EC<=entropy))];
    remainc=setdiff(wholec,c);
    entropy=ENT(data(r,c));
    tiji=[tiji; sum(r)+sum(c)];
end

% r=r';
[biaoqian,rb,rm]=calculatelabel(label(r),confidence);

   if (ENT(data(r,c))<=delta)&&(length(r)>=4)&&(length(c)>=3&&abs(biaoqian)==1)   
         rule=[length(r) length(c) c  mean(data(r,c)) r ENT(data(r,c)) biaoqian];
   else
      rule=[length(r) length(c) c  mean(data(r,c)) r ENT(data(r,c)) 0]; 
   end



end