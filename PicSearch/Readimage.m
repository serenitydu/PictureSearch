function Readimage(path)
img_path_list = dir(strcat(path,'*.jpg'));%��ȡ���ļ���������jpg��ʽ��ͼ��  
img_num = 5%length(img_path_list);%��ȡͼ��������  
Pictures=cell(1,img_num);
     for j = 1:img_num %��һ��ȡͼ��  
         if img_path_list(j).name =='.'
             fprintf('%d %d %s\n',j,strcat(path,image_name));
             % ��ʾ���ڴ�����ļ�����ɸѡ��ͼ���ļ�
         else
            image_name = img_path_list(j).name;% ͼ����  
            image =  imread(strcat(path,image_name));  
            fprintf('%d %d %s\n',j,strcat(path,image_name));% ��ʾ���ڴ����ͼ����
            Pictures{1,j}=image; 
         end            
      end  
save Pictures Pictures;
