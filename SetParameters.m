% 'p = [px, py, sx, sy, theta]'; 
% the location of the target in the first frame.
%      
% px and py are the coordinates of the center of the box;
%
% sx and sy are the size of the box in the x (width) and y (height)
% dimensions, before rotation;
%
% theta is the rotation angle of the box;
% 'affsig';
% these are the standard deviations of the dynamics distribution, and it controls the scale, size and area to 
% sample the candidates.
%    affsig(1) = x translation (pixels, mean is 0)
%    affsig(2) = y translation (pixels, mean is 0)
%    affsig(3) = x & y scaling
%    affsig(4) = rotation angle
%    affsig(5) = aspect ratio
%    affsig(6) = skew angle

%%******Change 'title ' to choose the sequence you wish to run******%%
switch (title) 
case 'football';     
 p = [330, 125, 50, 50, 0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
          'batchsize',10, 'affsig',[2,2,.001,.02,.001,.003]); 

case 'boy'
p=[288+17.5,143+21,35,42,0];
opt = struct('numsample',600, 'condenssig',0.75, 'ff',0.99, ...
 'batchsize',5, 'affsig',[10, 10,.001,.001,.0001,.0001]);

case'face'
p = [293 283 94	114 0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
              'batchsize',5, 'affsig',[20,20,.01,0.005,0.0005,0.0005]);  

case 'occlusion1'; 
p = [177,147,115,145,0];
opt = struct('numsample',100, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[4,4,.01,.00,.00,.000]);         

case 'caviar2';   
p = [ 152, 68, 18, 61, 0.00 ];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[2,1,.001,.000,.0005,.0005]);   
                 
case 'car4'; 
p = [245 180 200 150 0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[5,5,.025,.01,.002,.001]); 

case 'car11';  
p = [89 140 30 25 0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[2,2,.01,.00,.0005,.0005]);      

case 'deer';  
p = [350, 40, 100, 70, 0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[25,25,.000,.000,.000,.000]); 

case 'davidoutdoor'; 
p = [102,266,40,134,0.00];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[6,3,.00,.000,.00,.000]);     
    
case 'jumping';         
p = [163,126,33,32,0];
opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
             'batchsize',5, 'affsig',[10,25,.0005,.000,.0001,.0001]);     
                 
otherwise;  error(['unknown title ' title]);
end
%%******Change 'title' to choose the sequence you wish to run******%%
%%***************************Creat savepath*****************************%%
dataPath = [ '.\' title '\'];
savePath= [ 'Result\' title '\'];
    if ~isdir(['Results/',title])
        mkdir(['Results/',title])
    end  
%%***************************Creat savepath*****************************%%