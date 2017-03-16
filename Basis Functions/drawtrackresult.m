function drawopt = drawtrackresult(drawopt, fno, frame, tmpl, param)


if (isempty(drawopt))       
  figure('position',[0 0 size(frame,2),size(frame,1)]); clf;                               
  set(gcf,'DoubleBuffer','on','MenuBar','none');
  colormap('gray');
  drawopt.curaxis = [];
  drawopt.curaxis.frm  = axes('position', [0.00 0 1.00 1.0]);
end


curaxis = drawopt.curaxis;
axes(curaxis.frm);      
imagesc(frame, [0,1]); 
hold on;     

sz = size(tmpl.mean);  
drawbox(sz, param.est, 'Color','r', 'LineWidth',2);


text(5, 18, num2str(fno), 'Color','r', 'FontWeight','bold', 'FontSize',20);

axis equal tight off;
hold off;

drawnow;        

