# read_config
Very simple function which reads a config file. Config file must have the following format:
```
% comment
name =
array
name = num
name = string
```

# Installation instructions:
```
git clone https://github.com/justinblaber/read_config.git
```
Then, in MATLAB:
```
>> addpath('read_config');
```
You can try it out by creating a test config file, `test.conf`, containing:
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
>> read_data('test.conf')

ans = 

  struct with fields:

    test_string: ""
       test_num: 1
     test_array: [3×3 double]
```
