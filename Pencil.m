function result = Pencil(Ori,Tone)

% Stroke Structure Generation

[H,W,sc] = size(Ori);
doubleOri = im2double(Ori);
if Tone == 0
    Img = rgb2gray(doubleOri);
    result = Generate(Img,H,W,sc);
else
    array = doubleOri(:);
    number = length(array);
    satur = 0;
    for index = 1:number
       if array(index) < 0.25
           satur = satur+1;
       end
    end
    Satur = satur/number;
    hsvImg = rgb2hsv(doubleOri);
    Img1 = hsvImg(:,:,3);
    hsvImg(:,:,3) = Generate(Img1,H,W,sc);
    if Satur > 0.2
        result = histeq(hsv2rgb(hsvImg));
    else
        result = hsv2rgb(hsvImg);
    end
end

end