function Readimage(path)
img_path_list = dir(strcat(path,'*.jpg'));%获取该文件夹中所有jpg格式的图像  
img_num = 5%length(img_path_list);%获取图像总数量  
Pictures=cell(1,img_num);
     for j = 1:img_num %逐一读取图像  
         if img_path_list(j).name =='.'
             fprintf('%d %d %s\n',j,strcat(path,image_name));
             % 显示正在处理的文件名，筛选非图像文件
         else
            image_name = img_path_list(j).name;% 图像名  
            image =  imread(strcat(path,image_name));  
            fprintf('%d %d %s\n',j,strcat(path,image_name));% 显示正在处理的图像名
            Pictures{1,j}=image; 
         end            
      end  
save Pictures Pictures;
