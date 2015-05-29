%% Stereo camera calibration
% PARAMETERS:
% Number of images
num_imgs = 40;
% Square size (in millimeters)
square_size = 40;
% Path to the image folder
image_folder = '/home/miquel/Downloads/calibration';

left_imgs = cell(num_imgs, 1);
right_imgs = cell(num_imgs, 1);
image_dir = fullfile(image_folder);
for i = 1:num_imgs
    left_imgs{i} = fullfile(image_dir, sprintf('left-%04d.png', i));
    right_imgs{i} = fullfile(image_dir, sprintf('right-%04d.png', i));
end

% Detect the checkerboard
[image_points, board_size, pairs_used] = detectCheckerboardPoints(left_imgs, right_imgs);

k = find(pairs_used==0);
if ~isempty(k)
   fprintf('WARNING: Chessboard at %i is not correctly detected and has been discarded\n',k); 
end
    

images1 = left_imgs(pairs_used);
figure;
for i = 23:26
      I = imread(left_imgs{i});
      subplot(2, 2, i-22);
      imshow(I); hold on; plot(image_points(:,1,i,1), image_points(:,2,i,1), '*g-');
end
annotation('textbox', [0 0.9 1 0.1], 'String', 'Camera 1', 'EdgeColor', 'none', 'HorizontalAlignment', 'center')

% Generate world coordinates of the checkerboard points.
world_points = generateCheckerboardPoints(board_size, square_size);  

% Compute the stereo camera parameters.
[stereo_params, estimation_pairs_used, estimation_errors] = estimateCameraParameters(image_points, world_points, 'NumRadialDistortionCoefficients', 3, 'EstimateTangentialDistortion', true);

k = find(estimation_pairs_used==0);
if ~isempty(k)
   fprintf('WARNING: Stereo parameters at %i have been discarded\n',k); 
end

% Evaluate calibration accuracy.
figure;
showReprojectionErrors(stereo_params);