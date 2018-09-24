clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Parametres divers :
N = 90;					% Nombre de disques initial d'une configuration
R = 10;					% Rayon des disques
R_carre = R*R;
nb_points_disque = 30;
increment_angulaire = 2*pi/nb_points_disque;
theta = 0:increment_angulaire:2*pi;
rose = [253 108 158]/255;
q_max = 120;
nb_valeurs_a_afficher = 30;
pas_entre_deux_affichages = floor(q_max/nb_valeurs_a_afficher);
temps_affichage = 0.01;
beta = 0.3;
S = 130;
gamma = 5.0;
T0 = 0.1;
lambda0 = 100.0;
alpha = 0.99;

% Lecture et affichage de l'image :
I = imread('colonie.png');
I = rgb2gray(I);
I = double(I);
I = I(100:500,100:500);
[nb_lignes,nb_colonnes] = size(I);
figure('Name',['Detection de n flamants roses'],'Position',[0,0,L,0.65*H]);

lambda = lambda0;
T = T0;

abscisses_disques = [];
ordonnees_disques = [];
nvg_moyens_disques = [];
U_ad = [];


valeurs_q = [0];
tab_U = [0];
U_decr = U_ad;

% Dectection de flamants roses par processus ponctuel marqué
for q = 1:q_max
    N_rand = poissrnd(lambda);
    U_ad = U_decr;
    
    for k = 1:N_rand
        abscisse_nouveau = nb_lignes*rand;
        ordonnee_nouveau = nb_colonnes*rand;
        nvg_moyen_nouveau = nvg_moyen(abscisse_nouveau,ordonnee_nouveau,R,I);
        nvg_moyens_disques = [nvg_moyens_disques, nvg_moyen_nouveau];
        U_ad = [U_ad, 1 - (2 / (1+ exp(-gamma * (nvg_moyen_nouveau/S - 1)))) ];
        abscisses_disques = [abscisses_disques,abscisse_nouveau];
        ordonnees_disques = [ordonnees_disques,ordonnee_nouveau];
    end
     
    [U_decr, indice] = sort(U_ad, 'descend');
    abscisses_disques = abscisses_disques(indice);
    ordonnees_disques = ordonnees_disques(indice);
     
   
    N = length(abscisses_disques);
    z = 1;
    while z <= N
        diff_energie = - U_decr(z) + beta - beta * size(find((ordonnees_disques - ...
             ordonnees_disques(z) * ones(size(ordonnees_disques))).^2 + (abscisses_disques ...
             - abscisses_disques(z) * ones(size(abscisses_disques))).^2 < 2 * R^2), 2);
         
        p = lambda / (lambda + exp(diff_energie/T));
        if p > rand
            abscisses_disques(z)=[];
            ordonnees_disques(z)=[];
            U_decr(z) = [];
            N = length(abscisses_disques);
        end
        z = z + 1; 
    end
    
    lambda = lambda * alpha;
    T = T * alpha;   
    
	if rem(q,pas_entre_deux_affichages) == 0
		valeurs_q = [valeurs_q q];
        hold off;
		subplot(1,2,1);
		imagesc(I);
		axis image;
		axis off;
		colormap gray;
        hold on;
		for k = 1:N
			abscisses_affichage = abscisses_disques(k)+R*cos(theta);
			ordonnees_affichage = ordonnees_disques(k)+R*sin(theta);
            
			indices = find(...
                abscisses_affichage>0 & abscisses_affichage<nb_colonnes...
				& ordonnees_affichage>0 & ordonnees_affichage<nb_lignes);
            
			plot(abscisses_affichage(indices),ordonnees_affichage(indices),'.-','Color',rose,'LineWidth',3);
		end
		pause(temps_affichage);
        
        hold off
		subplot(1,2,2);
        U = sum(U_ad) + N*beta;
        for k = 1:N
            U = U - beta*size(find((ordonnees_disques - ordonnees_disques(k) * ones(size(ordonnees_disques))).^2 ...
            + (abscisses_disques - abscisses_disques(k) * ones(size(abscisses_disques))).^2 < 2 * R^2), 2);
        end
        tab_U = [tab_U, U];
        plot(valeurs_q,tab_U,'.-','Color',rose,'LineWidth',3);
        hold off
		axis([0 q_max -400 0]);
		set(gca,'FontSize',20);
		hx = xlabel('Nombre d''itérations','FontSize',30);
		hy = ylabel('Energie de la configuration','FontSize',30);
        hold on;
	end
end
