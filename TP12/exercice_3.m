clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load('base_donnees.mat', 'titres_auteurs_empreintes')


% Choix d'un titre
num_chanson = 1 + floor(9 * rand);

%% Lecture du morceau correspondant et de son empreinte sonore 
% Lecture d'un extrait musical :
[signal,f_echantillonnage] = audioread(['Base/extrait' num2str(num_chanson) '.wav']);
%%%%%
sound(signal,f_echantillonnage);
%%%%%%
if size(signal,2)==2
	signal = mean(signal,2);		% Conversion stereo -> mono
end

% Calcul de la transformee de Gabor :
nb_echantillons = length(signal);
duree = floor(nb_echantillons/f_echantillonnage);
duree_mesure = 0.2;				% Duree d'une mesure en secondes
nb_mesures = floor(duree/duree_mesure);
valeurs_t = 0:duree/(nb_mesures-1):duree;
nb_echantillons_par_mesure = floor(nb_echantillons/nb_mesures);
TG = T_Gabor(signal,nb_echantillons_par_mesure);

% Bande de frequences audibles :
f_min = 20;
f_max = 2000;
pas_f = f_echantillonnage/nb_echantillons_par_mesure;
valeurs_f_S = 0:pas_f:f_max;
nb_echantillons_f_S = length(valeurs_f_S);

% Calcul du sonagramme complexe :
S = TG(1:nb_echantillons_f_S,:);

% Affichage du sonagramme :
figure('Name','Sonagramme','Position',[0,0,0.5*L,0.67*H]);
imagesc(valeurs_t,valeurs_f_S,abs(S));
axis xy;
set(gca,'FontSize',20);
xlabel('Temps ($s$)','Interpreter','Latex','FontSize',30);
ylabel('Frequence ($Hz$)','Interpreter','Latex','FontSize',30);
drawnow;

% Calcul de la partition frequentielle :
nb_bandes = 6;
partition = exp(log(f_min):(log(f_max)-log(f_min))/nb_bandes:log(f_max));
indices_partition = zeros(1,nb_bandes);
for i = 1:nb_bandes
	indices_partition(i) = min(find(valeurs_f_S>partition(i)));
end
indices_partition(end+1) = length(valeurs_f_S);

% Calcul de l'empreinte sonore :
ES_extrait = calcul_ES(S,indices_partition,valeurs_t,valeurs_f_S);


%% Recherche de la meilleur correspondance avec chacune des m empreintes sonores de la base
meilleur_score = Inf;
indice_meilleur_score = -1; 

% nombre de morceaux dans la base de données
m = length(titres_auteurs_empreintes);

for ind=1:m 
        ES_nuages = titres_auteurs_empreintes{1,ind}.empreinte;
    
        % Recalage sur le morceau entier :
        figure('Name',['Recalage sur ', titres_auteurs_empreintes{1,ind}.titre] ,'Position',[0,0,L,0.67*H]);
        %load nuages;			% Lecture de l'empreinte sonore du morceau entier
        nb_mesures_morceau_entier = floor(max(ES_nuages(:,1))/duree_mesure);
        pas = 5;
        i_min = -1;
        score_min = Inf;
        for i = 0:pas:nb_mesures_morceau_entier-nb_mesures

            % Decalage temporel :
            delta_t = i*duree_mesure;

            % Affichage de l'empreinte sonore du morceau entier :
            clf;
            plot(ES_nuages(:,1),log(ES_nuages(:,2)/f_min),'o','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',5);
            set(gca,'FontSize',20);
            xlabel('$t$ ($s$)','Interpreter','Latex','FontSize',30);
            ylabel('$\log\left(f/f_{\min}\right)$','Interpreter','Latex','FontSize',30);
            hold on;

            %%%%%%%
            ES_sub = ES_extrait;
            ES_sub(:,1) = ES_sub(:,1)+delta_t;
            plot(ES_sub(:,1),log(ES_sub(:,2)/f_min),'o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',5);
            %%%%%%%

            % Affichage de l'empreinte sonore de l'extrait apres decalage, et calcul du score :
            score = decalage_ES(ES_extrait,delta_t,ES_nuages,f_min);
            % meilleur score ? :
            if score < score_min
                    i_min = i;
                    score_min = score;
            end
            pause(0.01);
        end
  
        
        % Affichage de l'empreinte sonore du morceau entier :
        clf;
        plot(ES_nuages(:,1),log(ES_nuages(:,2)/f_min),'o','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',5);
        set(gca,'FontSize',20);
        xlabel('$t$ ($s$)','Interpreter','Latex','FontSize',30);
        ylabel('$\log\left(f/f_{\min}\right)$','Interpreter','Latex','FontSize',30);
        hold on;

        % Calcul et affichage du meilleur recalage de l'extrait sur le morceau entier :
        delta_t_min = i_min*duree_mesure;
        ES = ES_extrait;
        ES(:,1) = ES(:,1)+delta_t_min;
        plot(ES(:,1),log(ES(:,2)/f_min),'o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5)    
        if score_min < meilleur_score
            meilleur_score = score_min;
            indice_meilleur_score = ind;
        end
       
end

titre_reconnu = titres_auteurs_empreintes{1,indice_meilleur_score}.titre;
disp(['titre de la chanson: (( ' titre_reconnu ' )), Meilleur score obtenu = ' num2str(meilleur_score) ]);
