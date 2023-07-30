% Add the path to the image files
img_dir_path = '/MATLAB Drive/test_5image';

% Save path for augmented images
savepath = '/MATLAB Drive/test_argumentfile';

% List all image files in the directory
fileList = dir(fullfile(img_dir_path, '*.jpg'));


for i = 1:length(fileList)
    filename = fileList(i).name;
    img_path = fullfile(img_dir_path, filename);
    image = imread(img_path);

    % Generate augmented images and save them
    % 1. Random Rotation between -30 and 30 degrees
    for j = 1:2
        angle = randi([-30, 30]);
        rotated_image = imrotate(image, angle, 'bilinear', 'crop');
        new_filename = sprintf('%s_rotated_%d.jpg', filename, j);
        imwrite(rotated_image, fullfile(savepath, new_filename));
    end

    % 2. Random Brightness Adjustment between 50% to 90%
    for j = 1:2
        brightness_range = rand(1) * 0.4 + 0.5;
        brightened_image = imadjust(image, [], [], brightness_range);
        new_filename = sprintf('%s_brightness_darkrange_%d.jpg', filename, j);
        imwrite(brightened_image, fullfile(savepath, new_filename));
    end

    % 3. Brightness Adjustment between 1.0 to 1.3
    for j = 1:2
        brightness_factor = rand(1) * 0.3 + 1.0;
        brightened_image = image .* brightness_factor;
        brightened_image = min(brightened_image, 255); % Ensure pixel values don't exceed 255
        new_filename = sprintf('%s_brightness_brightrange_%d.jpg', filename, j);
        imwrite(brightened_image, fullfile(savepath, new_filename));
    end

    % 4. Channel Shift (Brightness + Color)
    for j = 1:2
        channel_shift_range = randi([-30, 30]);
        shifted_image = image + channel_shift_range;
        shifted_image = min(shifted_image, 255); % Ensure pixel values don't exceed 255
        new_filename = sprintf('%s_channel_shift_range_%d.jpg', filename, j);
        imwrite(shifted_image, fullfile(savepath, new_filename));
    end

end
