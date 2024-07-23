const http = require('http');
const express = require('express');
const cors = require('cors');
const path = require('path');
const multer = require('multer');
const router = require('./src/routes/router');
const bodyParser = require('body-parser');

const app = express();

// cors 임시 전체 허용
app.use(cors());

// JSON 형식의 데이터 처리 - router보다 이거 먼저 써야함 전체 적용을 위해
app.use(bodyParser.json());
// URL 인코딩 데이터 처리
app.use(bodyParser.urlencoded({ extended: true }));

// 업로드된 파일을 저장할 경로 설정
const upload = multer({ dest: 'uploads/' });

// 정적 파일 제공 설정 (업로드된 파일)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// 라우터를 애플리케이션에 등록
app.use('/', router);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`웹서버 구동... ${port}`);
});
