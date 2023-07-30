# matlab_contest

## 주제 : HAPAGO, 얼굴 인식 알고리즘을 기반으로 유사한 하회탈 추정
서울과학기술대학교 고민지, 이승연, 양소연 
### Ⅰ. Introduction
 인공지능은 현재 의료 분야를 포함하여 다양한 분야에서의 적용과 연구가 활발하게 이루어지고 있습니다. 그러나 문화 체험과 관련해서는 인공지능의 활용은 아직 많이 알려져 있지 않습니다. 특히, 우리 문화의 한 부분인 하회탈을 바탕으로 인공지능을 활용하는 아이디어는 아직까지 거의 언급되지 않은 것으로 확인됩니다.
 
 이러한 상황을 바탕으로, 한국 전통 문화 체험에 인공지능을 융합하고자 합니다. 하회탈은 경상북도 안동시 풀천면 하회마을에서 전통 놀이와 지배 계급에 대한 비판을 담아 나무 가면으로 만들어지는 예술적인 유산입니다. 이러한 하회탈을 활용하여, 사용자들에게 자신과 가장 닮은 하회탈을 추정하는 프로그램을 개발하고자 합니다.
 
 우리의 프로젝트는 다양한 인공지능 기술과 이미지 처리 알고리즘을 활용하여, 사용자가 제공하는 사진을 분석하고 유사한 하회탈을 찾아내는 시스템을 구축하는 것을 목표로 합니다. 이를 통해 우리는 인공지능 기술을 우리의 문화와 접목함으로써, 전통적이고 독특한 문화를 현대에 맞게 재해석하고 새로운 형태의 문화 체험을 제공할 수 있을 것으로 기대합니다.


### Ⅱ. Data and Method
#### 2.1 Overall Model Organization
본 프로젝트에서 고안한 '유사한 하회탈 추정 모델'은 다음과 같이 구성되어 있다
![4dZRKsIgPJ4m0GIV8HrIamEzxESP5fD1GT6gRufRK8e6Si9s-sH5VFayZ9oNvwNgLASxzJbIBI2bw0yIeaEHilJf6zFb33gwdlTpX7JgO6IpdYgnC-3A--VW-_cb](https://github.com/mmmjii/2023_matlab_contest/assets/107604539/d63e1889-4de1-4a3e-b828-1e8926e02eb3)

먼저, 입력 이미지 데이터에 대해 68 Face Landmarks를 이용하여 68개의 특징점을 구한다. 이러한 특징점을 활용하여 턱의 각도, 눈의 폭과 길이의 비율 등 모델에서 사용되는 특징들의 값을 계산한다. 특징값들을 기반으로 지도학습방법으로 학습된 머신러닝 모델이 유사한 하회탈을 추정한다.




#### 2.2 data
데이터 출처 : https://www.kaggle.com/datasets/atulanandjha/lfwpeople

 이 프로젝트에서는 Kaggle 사이트를 통해 얻은 유명한 사람들의 얼굴 이미지 데이터를 활용합니다. 데이터 세트에는 정면을 보는 사람들의 JPEG 사진 모음이 포함되어 있으며, 각 이미지는 한 얼굴을 중심으로 합니다. 각 픽셀의 RGB 색상은 0.0에서 1.0 범위의 플로트로 인코딩되어 있습니다.

 원본 데이터 수는 총 ### 개이며, 옆을 바라보는 사진들은 얼굴 형태와 눈의 각도를 계산하는데 있어서 오른쪽 얼굴과 왼쪽 얼굴의 차이가 크기 때문에 정면을 보는 사진들만을 사용하였습니다. 얼굴 특징점을 사용하여 턱의 각도와 눈꼬리 각도를 측정하여 각도 분포에 근거하여 정면사진을 걸러냈습니다. 추가로 눈, 코, 입, 턱이 가려있는 이미지들도 걸러냈습니다.

 데이터의 특징으로는 성별을 구분하지 않았습니다. 하회탈은 주로 각 집단의 지위와 역할에 맞게 부네탈, 양반탈, 초랭이탈, 할미탈 등으로 만들어지는데, 이러한 가면들은 당시 인물들의 모습을 반영하도록 제작되었습니다. 성별의 특징보다는 주어진 얼굴 이미지에서 공통적으로 드러나는 특징이 하회탈의 구분에 더 큰 영향을 미칠 것으로 판단하여 성별을 나누지 않았습니다.

 또한, 연령대 정보를 포함하지 않았습니다. 인터넷에서 수집한 사진들은 연령대 별로 데이터 분포를 고려하지 않고, 나이가 들어 보이는 인물의 사진만을 따로 모아 사용하였습니다. 나이가 들어질수록 눈가가 쳐지기 때문에 이러한 요소가 하회탈 구분에 영향을 줄 수 있다고 판단하였습니다.

 데이터 증강은 MATLAB 코드를 활용하여 다음과 같이 수행하였습니다.
 
1. 랜덤하게 30도 ~ 30도 사이로 회전 변환
2. 이미지의 밝기가 50%에서 90% 사이의 무작위 값으로 조정하는 밝기 변화
3. 이미지의 밝기를 1배에서 1.5배 사이의 무작위 값으로 변화시키는 밝기 변화
4. 채널 변화 (밝기 + 색감)을 적용하는 가우시안 브러쉬 처리

추가로 python 코드를 사용하여 블러 처리를 한 증강 기법을 수행하였습니다. 

5. 가우시안 블러 처리 변화 (‘(45, 45)’ 크기의 블러와 ‘0’ 표준편차 값 사용)

각 증강 기법당 2개의 랜덤 이미지를 증강하여 총 1 이미지당 10개의 증강 이미지가 생성되었습니다. 


#### 2.3 method
Dlib의 68 Landmark 알고리즘을 사용하여 얼굴 이미지 당 68개의 특징점을 얻었습니다. 이 68개의 랜드마크 지점은 얼굴, 눈, 코, 그리고 입 주변의 테두리에 위치합니다. 우리는 이 68개의 특징점 위치를 기반으로 ##가지 특징을 만들었습니다. 각 특징은 두 개의 랜드마크를 연결하는 두 선 사이의 각도의 비율 또는 코사인 값을 나타냅니다. 이 특징들의 계산 공식은 ###에 나와 있습니다.

F1과 F2는 각 눈의 높이를 해당 눈의 너비로 나눈 비율을 의미합니다. F3과 F4는 왼쪽 눈과 오른쪽 눈의 끝점을 연결하는 선과 코의 상단과 하단 끝점을 연결하는 선 사이의 각도의 코사인 값을 의미합니다. F7과 F8은 한 폭을 다른 폭으로 나눈 비율입니다. F7은 광대뼈를 지나는 폭을 인줄기를 지나는 폭으로 나눈 비율을 나타냅니다. F8은 인줄기를 지나는 폭을 턱을 지나는 폭으로 나눈 비율을 나타냅니다. F9는 얼굴의 하단 높이를 가운데 높이로 나눈 비율을 의미합니다. F10은 광대뼈를 지나가는 폭을 가운데 높이와 하단 높이의 길이로 나눈 비율을 나타냅니다.

+ 2.3.1 Tal Feature Extraction
+ 2.3.2 Tal Labeling
+ 2.3.3 Face Labeling

#### 2.4 modeling
+ 2.4.1 RF
+ 2.4.2 SVM_POLY
+ 2.4.3 SVM_RBF
+ 2.4.4 CNN
### III. Results

### IV. Discussion

### V. Conclusion

### References
