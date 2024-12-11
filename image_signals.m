% Görkem Kadir Solun 22003214

clear;
clc;
close all;

% Read and prepare the original image
I = imread('flower.jpg');
A = mat2gray(rgb2gray(I));

% Define filter sizes
filter_sizes = [3, 10, 50];

% ------------------------------------------------------------
% QUESTION 1
% PART 1: Custom convolution on original image
% ------------------------------------------------------------

perform_custom_convolution(A, filter_sizes, 'Original Image');

% Compare with built conv2 results
figure;

for i = 1:length(filter_sizes)
    f = ones(filter_sizes(i)) / (filter_sizes(i) ^ 2);
    output_image_built = conv2(A, f, 'same');
    subplot(2, 2, i);
    imshow(output_image_built, []);
    title(['N=', num2str(filter_sizes(i)), ' Built']);
end

subplot(2, 2, 4), imshow(A), title('Original Image');

% ------------------------------------------------------------
% QUESTION 1
% PART 2: Add noise and repeat
% ------------------------------------------------------------

noisy_image = A + 0.1 * randn(size(A));
figure;
imshow(noisy_image, []), title('Noisy Image');
perform_custom_convolution(noisy_image, filter_sizes, 'Noisy Image');

% ------------------------------------------------------------
% QUESTION 2: Linearity test with combined images
% ------------------------------------------------------------

image1 = im2double(imread('image1.png'));
image2 = im2double(imread('image2.png'));
filter_10 = ones(10, 10) / 100;

smoothed_combined = custom_convolution(10 * image1 + 5 * image2, filter_10);
smoothed_image1 = custom_convolution(10 * image1, filter_10);
smoothed_image2 = custom_convolution(5 * image2, filter_10);

figure;
subplot(1, 2, 1), imshow(smoothed_combined, []), title('Filtered Combined Image');
subplot(1, 2, 2), imshow(smoothed_image1 + smoothed_image2, []), title('Sum of Individually Filtered Images');

% ------------------------------------------------------------
% QUESTION 3: Detect occurrences of 't' in a text image
% ------------------------------------------------------------

text_image = im2double(imread('Text.png'));
letter_t = im2double(imread('lettert.png'));
horizontal_text = text_image(1:55, 1:200);

conv_result = custom_convolution(horizontal_text, letter_t);
normalized_result = rescale(conv_result);
detected_peaks = normalized_result > 0.95;
num_t_horizontal = sum(detected_peaks(:));

figure;
subplot(1, 3, 1), imshow(text_image), title('Original Text Image');
subplot(1, 3, 2), imshow(horizontal_text), title('Horizontal Text');
subplot(1, 3, 3), imshow(detected_peaks), title(['Detected "t": ', num2str(num_t_horizontal)]);

%% Local Functions

function output_image = custom_convolution(image, filter)
    [filter_rows, filter_columns] = size(filter);
    [image_rows, image_columns] = size(image);
    output_image = zeros(image_rows - filter_rows + 1, image_columns - filter_columns + 1);

    for i = 1:size(output_image, 1)

        for j = 1:size(output_image, 2)
            local_region = image(i:i + filter_rows - 1, j:j + filter_columns - 1);
            output_image(i, j) = sum(sum(local_region .* filter));
        end

    end

end

function perform_custom_convolution(image, filter_sizes, name)
    figure;

    for i = 1:length(filter_sizes)
        f = ones(filter_sizes(i)) / (filter_sizes(i) ^ 2);
        output_image = custom_convolution(image, f);
        subplot(2, 2, i);
        imshow(output_image, []);
        title(['N=', num2str(filter_sizes(i))]);
    end

    subplot(2, 2, length(filter_sizes) + 1);
    imshow(image);
    title(name);
end
