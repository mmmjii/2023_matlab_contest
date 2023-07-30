# Matlab_contest
서울과학기술대학교 고민지, 이승연, 양소연 
## 주제 : HAPAGO, 얼굴 인식 알고리즘을 기반으로 유사한 하회탈 추정

### Ⅰ. Introduction
 인공지능은 현재 의료 분야를 포함하여 다양한 분야에서의 적용과 연구가 활발하게 이루어지고 있습니다. 그러나 문화 체험과 관련해서는 인공지능의 활용은 아직 많이 알려져 있지 않습니다. 특히, 우리 문화의 한 부분인 하회탈을 바탕으로 인공지능을 활용하는 아이디어는 아직까지 거의 언급되지 않은 것으로 확인됩니다.
 
 이러한 상황을 바탕으로, 한국 전통 문화 체험에 인공지능을 융합하고자 합니다. 하회탈은 경상북도 안동시 풀천면 하회마을에서 전통 놀이와 지배 계급에 대한 비판을 담아 나무 가면으로 만들어지는 예술적인 유산입니다. 이러한 하회탈을 활용하여, 사용자들에게 자신과 가장 닮은 하회탈을 추정하는 프로그램을 개발하고자 합니다.
 
 우리의 프로젝트는 다양한 인공지능 기술과 이미지 처리 알고리즘을 활용하여, 사용자가 제공하는 사진을 분석하고 유사한 하회탈을 찾아내는 시스템을 구축하는 것을 목표로 합니다. 이를 통해 우리는 인공지능 기술을 우리의 문화와 접목함으로써, 전통적이고 독특한 문화를 현대에 맞게 재해석하고 새로운 형태의 문화 체험을 제공할 수 있을 것으로 기대합니다.

----------
### Ⅱ. Data and Method
#### 2.1 Overall Model Organization
본 프로젝트에서 고안한 '유사한 하회탈 추정 모델'은 다음과 같이 구성되어 있다
![4dZRKsIgPJ4m0GIV8HrIamEzxESP5fD1GT6gRufRK8e6Si9s-sH5VFayZ9oNvwNgLASxzJbIBI2bw0yIeaEHilJf6zFb33gwdlTpX7JgO6IpdYgnC-3A--VW-_cb](https://github.com/mmmjii/2023_matlab_contest/assets/107604539/d63e1889-4de1-4a3e-b828-1e8926e02eb3)

먼저, 입력 이미지 데이터에 대해 68 Face Landmarks를 이용하여 68개의 특징점을 구한다. 이러한 특징점을 활용하여 턱의 각도, 눈의 폭과 길이의 비율 등 모델에서 사용되는 특징들의 값을 계산한다. 특징값들을 기반으로 지도학습방법으로 학습된 머신러닝 모델이 유사한 하회탈을 추정한다.

#### 2.2 data
데이터 출처 : https://www.kaggle.com/datasets/atulanandjha/lfwpeople

 이 프로젝트에서는 Kaggle 사이트를 통해 얻은 유명한 사람들의 얼굴 이미지 데이터를 활용합니다. 데이터 세트에는 정면을 보는 사람들의 JPEG 사진 모음이 포함되어 있으며, 각 이미지는 한 얼굴을 중심으로 합니다. 각 픽셀의 RGB 색상은 0.0에서 1.0 범위의 플로트로 인코딩되어 있습니다.

 원본 데이터 수는 총 ### 개이며, 정면을 보는 사진들만을 사용하였습니다. 그 이유로는 첫째, 본래 하회탈은 정면 부분만 존재하여 측면 등을 고려할 필요가 없다고 생각하였습니다. 두 번째로는 정면이 아닌 다른 곳을 바라보는 사진들은 이목구비에 대한 수치가 측정되지 않는 경우가 존재하여, 닮은 하회탈을 추정하는 데에 어려움이 있을 것이라 판단하였기 때문에 정면을 보는 사진만을 사용하였습니다. 정면을 바라보는 데이터를 걸러내는 기준으로는 얼굴의 특징점을 구한 뒤 좌/우 눈의 중앙에 위치한 점과 코의 중앙에 위치한 점을 이어 만들어진 각도를 구하여, 그 각이 90도에 가까우면 정면이라 판단 정면 사진을 걸러냈습니다. 추가로 눈, 코, 입, 턱이 가려져 있는 이미지들도 걸러냈습니다.

 데이터의 특징으로는 성별을 구분하지 않았습니다. 하회탈은 주로 각 집단의 지위와 역할에 맞게 부네탈, 양반탈, 초랭이탈, 할미탈 등으로 만들어지는데, 이러한 가면들은 당시 인물들의 모습을 반영하도록 제작되었습니다. 성별의 특징보다는 주어진 얼굴 이미지에서 공통적으로 드러나는 특징이 하회탈의 구분에 더 큰 영향을 미칠 것으로 판단하여 성별을 나누지 않았습니다.

 또한, 연령대 정보를 포함하지 않았습니다. 인터넷에서 수집한 사진들은 연령대 별로 데이터 분포를 고려하지 않고, 나이가 들어 보이는 인물의 사진만을 따로 모아 사용하였습니다. 나이가 들어질수록 눈가가 쳐지기 때문에 이러한 요소가 하회탈 구분에 영향을 줄 수 있다고 판단하였습니다.

 데이터 증강은 MATLAB 코드를 활용하여 다음과 같이 수행하였습니다.
 
1. 랜덤하게 30도 ~ 30도 사이로 회전 변환
2. 이미지의 밝기가 50%에서 90% 사이의 무작위 값으로 조정하는 밝기 변화
3. 이미지의 밝기를 1배에서 1.3배 사이의 무작위 값으로 변화시키는 밝기 변화
4. 채널 변화 (밝기 + 색감)을 적용하는 가우시안 브러쉬 처리

추가로 python 코드를 사용하여 블러 처리를 한 증강 기법을 수행하였습니다. 

5. 가우시안 블러 처리 변화 (‘(45, 45)’ 크기의 블러와 ‘0’ 표준편차 값 사용)

각 증강 기법당 2개의 랜덤 이미지를 증강하여 총 1 이미지당 10개의 증강 이미지가 생성되었습니다. 


#### 2.3 method
<img width="393" alt="image" src="https://github.com/mmmjii/2023_matlab_contest/assets/107604539/9b951ac7-0e9d-43b5-8ea7-4cc79ff997ed">

Dlib의 68 Landmark 알고리즘을 사용하여 얼굴 이미지 당 68개의 특징점을 얻었습니다. 이 68개의 랜드마크 지점은 얼굴, 눈, 코, 그리고 입 주변의 테두리에 위치합니다. 우리는 이 68개의 특징점 위치를 기반으로 6가지 특징을 만들었습니다. 각 특징은 두 개의 랜드마크를 연결하는 두 선 사이의 각도의 비율 또는 각도을 나타냅니다. 이 특징들의 계산 공식은 아래에 나와 있습니다.

F1는 이마쪽 사잇각 기준으로 한 눈 사이 각도를 의미합니다. F2과 F3는 왼쪽과 오른쪽 눈의 가로길이대 세로길이 비율을 의미합니다. F4는 코의 가로길이 대 세로길이 비율,입니다. F5은 턱 끝 각도를 나타냅니다.

+ 2.3.1 Tal Feature Extraction

  하회탈 이미지에서 68 Face Landmarks 알고리즘은 68개의 랜드마크를 추출하지 못했습니다. 그 대신 Adobe Photoshop 프로그램을 사용하여 68개의 랜드마크를 직접 그리게 되었습니다. 따라서 하회탈 이미지에서도 동일한 6가지 특징이 추출되었습니다.
+ 2.3.2 Tal Labeling
  
   기존에는 하회탈로 알려진 8개의 탈을 모두 사용하려고 했지만, 일부 탈들은 탈 사이가 크게 차이가 잘 나타나지 않아서 더 명확한 구분을 할 수 있도록 하기 위해, 탈 사이의 차이가 두드러지는 탈들을 중심으로 다음 4개의 탈을 사용하였습니다: 부네탈, 양반탈, 초랭이탈, 할미탈. 이 4개의 탈은 다양한 특징들을 고려하여 서로 다른 얼굴 특성을 대표하고 있으며, 라벨링을 통해 이미지에 가장 유사한 탈을 찾아낼 수 있도록 선택되었습니다.
  
  먼저, 탈 라벨링을 위해 거리 함수를 사용하여 각 이미지와 탈 사이의 유사도를 계산하고, 가장 작은 유사도 값을 가지는 탈로 라벨링하는 방법을 시도하였습니다. 그러나 이 방법을 사용할 때 다음 그림과 같이 클래스 불균형이 발생하여 문제가 발생했습니다.
  
  <img width="549" alt="image" src="https://github.com/mmmjii/2023_matlab_contest/assets/107604539/4b51959b-ba45-47d4-98d7-b5d533a3f7ad">

  
   이를 해결하기 위해 두 번째 시도에서는 각각의 탈을 더 세분화하여 탈 사이의 유사도를 계산하는 방법을 사용하였습니다. 하회탈 라벨링을 위해 5가지 특징을 사용했습니다. 이 특징들은 다음과 같습니다:
  
  1. 이마 쪽 사잇각을 기준으로 한 눈 사이 각도
  2. 왼쪽 눈 가로 길이 대 세로 길이 비율
  3. 오른쪽 눈 가로 길이 대 세로 길이 비율
  4. 코 가로 길이 대 세로 길이 비율
  5. 턱 끝 각도
    
  각 이미지에서 위의 특징들의 값을 추출하여 수치로 구합니다. 그다음 특징 값들을 정규화하여 스케일을 통일시켰습니다. 정규화 방법으로는 standard 정규화를 사용했습니다. 이를 통해 각 특징의 값이 평균이 0이고 표준편차가 1이 되도록 조정합니다.
  
  각 탈과의 닮은 정도를 측정하기 위해, 정규화된 특징 값들을 사용하여 탈과의 거리를 계산합니다. 이후 거리 함수를 통해 닮은 정도를 수치화하였습니다. 각 탈을 기준으로 평균 거리 수치에서 자기 거리 수치를 뺀 값이 가장 큰 탈로 라벨링을 진행하였습니다.

  

#### 2.4 modeling

우리는 라벨링 된 데이터를 사용하여 지도 학습 방법을 시도했습니다. 우리 프로젝트에서 수행하려는 것은 '분류(Classification)'였기 때문에 대표적인 분류 모델인 'RF', 'SVM-RBF', 'SVM-Poly', ‘SVM_CEOC’, 'CNN'을 사용했습니다. 

+ 2.4.1 RF
  
   RF(Random Forest)는 여러 개의 의사결정 트리로 구성된 분류 결과를 수집하여 결과를 얻는 모델입니다. 여러 개의 의사결정 트리는 약간 다른 특성을 가지기 때문에 결과적으로 일반화 성능이 향상됩니다. 이 모델의 매개변수는 다양하게 변할 수 있습니다. 그 중에서도 우리는 n_estimator와 max_depth을 사용하여 훈련을 시도해 보았습니다.

  n_estimator는 랜덤 포레스트의 의사결정 트리 개수를 나타내며, max_depth는 하나의 트리의 최대 깊이를 나타냅니다. 또한 max_depth의 기본값은 None으로, 이는 클래스 값이 완벽하게 결정될 때까지 분할된다는 의미입니다.
 먼저, 우리는 n_estimator를 100, max_depth를 None의 기본값으로 설정하여 모델을 훈련했습니다. 더 나은 성능을 위해 하이퍼파라미터 값을 찾기 위해 n_estimator를 100부터 500까지 100씩 증가시키고, max_depth를 10부터 100까지 5의 배수로 증가시키며 총 다섯 번의 그리드 서치를 수행했습니다.

+ 2.4.2 SVM

   SVM은 데이터를 선형적으로 최적으로 분리하는 경계를 찾는 모델입니다. 이는 '서포트 벡터'라고 불리는 데이터를 기반으로 전체 데이터를 분류하는 경로를 찾는 방법이기 때문에 SVM(서포트 벡터 머신)이라고 불립니다. 이 모델의 매개변수 중 하나인 C값은 오분류를 얼마나 허용할지를 나타내는 값입니다. C 값이 클수록 오분류를 적게 허용하며, C 값이 작을수록 오분류를 더 많이 허용합니다. 다시 말해, 지나치게 큰 C 값은 과적합의 위험을 가지고 있고, 지나치게 작은 C 값은 과소적합의 위험을 가지고 있습니다. 따라서 적절한 C 값을 찾는 것이 중요합니다.
  

  이를 활용하여 클래스 간 오분류 오차를 최소화하는 방향으로 학습하는 SVM_CEOC (오류 기반 클래스 지원 벡터 머신) 모델을 사용하였습니다. CEOC의 경우 C 값이 주요 하이퍼파라미터로, 적절한 오류 허용 범위를 설정하기 위해 그리드 서치를 수행하였습니다. 이 모델은 다중 레이블 분류에서 특히 효과적이며, 클래스 간 오분류를 감소시켜 더 나은 분류 결과를 얻을 수 있습니다.
 
  SVM 모델은 커널(kernel)이라는 요소에 따라 나눌 수 있습니다. 커널에는 Linear, Poly, RBF가 있습니다. Linear는 이름 그대로 데이터를 선형적으로 사용하는 경우입니다. 반면에 Poly와 RBF는 비선형 데이터에 사용되며, Poly의 경우 degree 매개변수, RBF의 경우 gamma 값을 추가적으로 조정해야 합니다.
저희 데이터셋의 경우 여러 개의 피처 값을 가지고 있기 때문에, 선형 대신 Poly와 RBF를 커널로 사용했습니다. 더 나은 성능을 위해 하이퍼파라미터를 찾기 위해 C 값과 gamma 값을 각각 기본 값과 함께 0.001부터 20까지 10개의 값으로 그리드 서치를 수행하였습니다.

+ 2.4.3 CNN


----------
### III. Results
----------
### IV. Discussion
----------
### V. Conclusion
----------
### References
