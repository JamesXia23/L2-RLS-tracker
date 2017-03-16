This code is a MATLAB implementation of the tracking algorithm described in the CSVT paper "L2-RLS based tracking" by Ziyang Xiao, Huchuan Lu and Dong Wang.


***********************************************************************
The code runs on Windows XP/7 with MATLAB R2009b.

Main MATLAB files:
  SetParamers.m : setting parameters up
  main.m : run tracking. Please adjust the variable 'vNum' to choose the video.
  L2_Tracker.m: tracking process
  

We include the  "caviar2" and "face" videos as two demos in this filefolder, please find the other videos in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html (a tracking benchmark proposed in reference [7]).
Test videos in this work and their website are listed below:
fileName_cell{1} = 'boy';  the "Boy" video in  http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html
fileName_cell{2} = 'car4';  the "Car4" video in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html
fileName_cell{3} = 'car11';  the "CarDark" video in  http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html  
fileName_cell{4} = 'caviar2';     
fileName_cell{5} = 'davidoutdoor'; the "David3" video in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html
fileName_cell{6} = 'deer';  the "Deer" video in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html
fileName_cell{7} = 'face';       
fileName_cell{8} = 'football'; the "Football" video in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html
fileName_cell{9} = 'jumping'; the "Jumping" video in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html
fileName_cell{10} = 'occlusion1'; the "FaceOcc1" video in http://cvlab.hanyang.ac.kr/tracker_benchmark_v10.html

Notes:
For each video, all the pictures should be named in the format "%0d.jpg" (like "11.jpg").
Also, please find the ground truth and data information files in the folder "GT", rename the "datainfo_videoname.txt" file as "datainfo.txt" and put them into the same folder with the images.

***********************************************************************
Thanks to Wu Yi, Jongwoo Lim, and Ming-Hsuan Yang for providing the benchmark videos. 
Thanks to the INRIA Labs for providing video Caviar2. (http://groups.inf.ed.ac.uk/vision/CAVIAR/CAVIARDATA1/)
Thanks to Wu Yi, Ling Haibin, Yu Jingyi, Li Feng, Mei Xue and Cheng Erkang for providing video Face.

***********************************************************************
Thanks to Jongwoo Lim and David Ross. The affine transformation part is derived from their code for "Incremental Learning for Robust Visual Tracking" (IJCV 2008) by David Ross, Jongwoo Lim, Ruei-Sung Lin and Ming-Hsuan Yang.


***********************************************************************
This is the version 1 of the distribution. We appreciate any comments/suggestions. For more quetions, please contact us at xiaoziyang1028@gmail.com or lhchuan@dlut.edu.cn or wangdong.ice@gmail.com
	
Ziyang, Huchuan Lu and Dong Wang 
Mar. 2014