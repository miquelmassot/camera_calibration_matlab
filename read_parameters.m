load stereo_parameters.mat
sp = stereo_params_final;
c1 = sp.CameraParameters1;
c2 = sp.CameraParameters2;

K1 = c1.IntrinsicMatrix;
D1 = [c1.RadialDistortion(1:2) c1.TangentialDistortion c1.RadialDistortion(3)];

K2 = c2.IntrinsicMatrix;
D2 = [c2.RadialDistortion(1:2) c2.TangentialDistortion c2.RadialDistortion(3)];

R = sp.RotationOfCamera2;
t = sp.TranslationOfCamera2;

P1 = cameraMatrix(c1,eye(3),[0 0 0]);
P2 = cameraMatrix(c1,R,t);