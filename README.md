# matlab_contest

## 주제 : HAPAGO, 얼굴 인식 알고리즘을 기반으로 유사한 하회탈 추정
### Ⅰ. Introduction
하회탈은 경상북도 안동시 풀천면 하회마을에서 만들어지는 나무 가면으로, 일반 시민들이 지배 계급을 비판하고 전통 놀이를 연기하기 위해 각 역할에 적합하게 만들어진 가면입니다. 주로 각 집단의 지위와 역할에 맞게 가각시탈, 초랭이탈, 중탈, 임마탈, 주저탈, 양반탈 등으로 만들어졌습니다. 이름에서 알 수 있듯이 이 가면들은 당시 인물들의 모습을 반영하도록 제작되었습니다. 따라서 사람과 하회탈 사이의 유사성을 도출하는 것이 동물과 사람 사이의 유사성을 찾는 것보다 쉽다고 할 수 있습니다. 대부분의 동물들은 사람과 다른 얼굴 특징을 가지고 있습니다. 예를 들어 코가 긴 코끼리가 그렇습니다. 그러나 하회탈의 경우, 인물의 모습을 반영하여 만들어져서 실제 사람과 거의 비슷한 특징을 갖고 있습니다. 따라서 사람과 하회탈 사이의 유사성을 찾는 과정은 사람과 동물 사이의 유사성을 찾는 것보다 쉬울 수 있습니다. 그럼에도 불구하고 아직 이러한 프로그램은 개발되지 않은 상태입니다.

본 논문에서는 위의 사실들에 주목하여 유사한 하회탈을 보여줄 수 있는 기계 학습 모델을 제안합니다. 먼저, 이 모델에서 사용된 데이터와 학습 방법을 살펴보고, 전체적인 구조, 운영 과정, 그리고 결과 분석을 살펴볼 것입니다.
 
### Ⅱ. Data and Method
#### 2.1 Overall Model Organization
본 프로젝트에서 고안한 '유사한 하회탈 추정 모델'은 다음과 같이 구성되어 있다

-------
이 부분에 전체적인 모델 구조도 추가 예정
-------
먼저, 입력 이미지 데이터에 대해 68 Face Landmarks를 이용하여 68개의 특징점을 구함. 

<img width="289" alt="image" src="https://github.com/mmmjii/2023_matlab_contest/assets/107604539/7d8a892b-e0de-431d-ac73-ba44b66b8da5">


이러한 특징점을 활용하여 턱의 각도, 눈의 폭과 길이의 비율 등 모델에서 사용되는 특징들의 값을 계산. 

특징값들을 기반으로 지도학습방법으로 학습된 머신러닝 모델이 유사한 하회탈을 추정함.

#### 2.2 data
데이터 출처 : https://www.kaggle.com/datasets/atulanandjha/lfwpeople

증명사진만을 사용한 데이터에서 눈코입이 다 보이는 사진까지 데이터 확장
- 정면사진만
    1차 : 정면 사진을 골라내는 코드 사용
    2차 : 얼굴 특징점을 사용하여 각도 측정 → 각도가 90도에 근접할수록 정면이라 판단(얼굴이 옆으로 돌아간 경우, 위 아래로 움직인 경우 모두 고려 가능 → 각도 분포에 근거해 90<= data <= 151 기준 설정 )

- 여성과 남성 데이터셋을 구분하지 않은 이유 → 각 성별의 특징이 하회탈의 특징에 큰 영향을 주지 않는다고 생각
- 각 연령대 별로 데이터 분포를 고려하지 않은 이유 → 인터넷에서 수집하는 사진들은 연령대 정보를 거의 포함하고 있지 않고 있음. 거의 영향력이 없다고 생각. 눈에 띄게 나이가 있어 보이는 인물(흰 머리, 주름)의 사진만 따로 모아 사용.(나이가 들수록 눈가가 쳐지기 때문에 이러한 요소가 하회탈 구분에 영향을 준다고 생각)

원자료 data : 1330개
증강후 data : 1330 x 11 = 14630개
데이터 증강 기법
1. 30도 ~ 30도 사이의 각도로 랜덤하게 회전 변환
2. 밝기 변화 (이미지의 밝기가 50%에서 90% 사이의 무작위 값으로 조정)
3. 밝기 변화 (이미지의 밝기가 1배에서 1.5배 사이의 무작위 값으로 변화 )
4. 채널 변화 (밝기 + 색감)
5. 가우시안 블러 처리 ( ‘(45, 45)’ 크기의 블러와 ‘0’ 표준편차 값 사용)

각 증강기법당 랜덤 이미지 2개 생성함. 그래서 한이미지를 증강했을경우에 추가로 10개의 이미지가 증강됨 


#### 2.3 method
Dlib의 68 Landmark 알고리즘을 사용하여 얼굴 이미지 당 68개의 특징점을 얻었습니다. 이 68개의 랜드마크 지점은 얼굴, 눈, 코, 그리고 입 주변의 테두리에 위치합니다. 우리는 이 68개의 특징점 위치를 기반으로 ##가지 특징을 만들었습니다. 각 특징은 두 개의 랜드마크를 연결하는 두 선 사이의 각도의 비율 또는 코사인 값을 나타냅니다. 이 특징들의 계산 공식은 ###에 나와 있습니다.

F1과 F2는 각 눈의 높이를 해당 눈의 너비로 나눈 비율을 의미합니다. F3과 F4는 왼쪽 눈과 오른쪽 눈의 끝점을 연결하는 선과 코의 상단과 하단 끝점을 연결하는 선 사이의 각도의 코사인 값을 의미합니다. F7과 F8은 한 폭을 다른 폭으로 나눈 비율입니다. F7은 광대뼈를 지나는 폭을 인줄기를 지나는 폭으로 나눈 비율을 나타냅니다. F8은 인줄기를 지나는 폭을 턱을 지나는 폭으로 나눈 비율을 나타냅니다. F9는 얼굴의 하단 높이를 가운데 높이로 나눈 비율을 의미합니다. F10은 광대뼈를 지나가는 폭을 가운데 높이와 하단 높이의 길이로 나눈 비율을 나타냅니다.

#### 2.4 modeling
+ 2.4.1 RF
+ 2.4.2 SVM_POLY
+ 2.4.3 SVM_
### III. Results

### IV. Discussion

### V. Conclusion

### References
