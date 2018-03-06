# read_data
Function which reads a "data" file. This is 

# Installation instructions:
```
git clone https://github.com/justinblaber/read_data.git
```
Then, in MATLAB:
```
>> addpath('read_data');
```
You can try it out by creating a "data" file, `test.conf`, containing:
```
test_string = string
test_num = 1
test_array = 
1 2 3
4 5 6
7 8 9
```
And then reading it
```
>> read_data('test.txt')

ans = 

  struct with fields:

    test_string: ""
       test_num: 1
     test_array: [3×3 double]
```
