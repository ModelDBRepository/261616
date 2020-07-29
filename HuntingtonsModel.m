% Model of the motor loop from the PFC to the PMC using BG pathways in the Huntington conditions.
% G. Mulcahy, B. Atwood and A. Kuznetsov. 
% Basal Ganglia role in learning rewarded actions and executing previously learned choices: 
% healthy and diseased states. PLoS ONE 2019.
clear all;
clf;

%variable initializations
input_pfc1 = 0.8; %synaptic input to PFC1
input_pfc2 = 0.0; %synaptic input to PFC2
t_constant = 1.0; %time constant
dt = 0.01; %delta t
drm = 1.3; %tonic drive to PMC neurons
wMinh = 1.6; %weight of inhibitory connection between PMC neurons
wgpi = 1.8; %weight between PMC neurons and GPi
learning_rate = 0.0005; %learning rate of PMC neurons
decay_rate = 0.0005; %decay rate of PMC neurons
wPFC1_PMC1 = 0.0;%weight between PFC1 and PMC1, will eventually change with learning
wPFC2_PMC1 = 0.0;%weight between PFC2 and PMC1, will eventually change with learning
wPFC1_PMC2 = 0.0;%weight between PFC1 and PMC2, will eventually change with learning
wPFC2_PMC2 = 0.0;%weight between PFC2 and PMC2, will eventually change with learning
wPFC1_D1_1 = 0.001*rand; %initial weight between first PFC neuron and first D1 MSN
wPFC1_D2_1 = 0.001*rand; %initial weight between first PFC neuron and first D2 MSN
wPFC1_D1_2 = 0.001*rand; %initial weight between first PFC neuron and second D1 MSN
wPFC1_D2_2 = 0.001*rand; %initial weight between first PFC neuron and second D2 MSN
wPFC2_D1_1 = 0.001*rand; %initial weight between second PFC neuron and first D1 MSN
wPFC2_D2_1 = 0.001*rand; %initial weight between second PFC neuron and first D2 MSN
wPFC2_D1_2 = 0.001*rand; %initial weight between second PFC neuron and second D1 MSN
wPFC2_D2_2 = 0.001*rand; %initial weight between second PFC neuron and second D2 MSN
expected_reward1 = 1.0; %initial reward expected by the SNc neuron
initial_e_r = expected_reward1; %saved value of the initial expected reward
trial_switch = 200; %trial at which the rewarded behavior will change
actual_reward1 = 1.0; %actual reward received from action 1
actual_reward2 = 0.0; %actual reward received from action 2
alpha_SNc = 0.15; %alpha used by SNc to update expected reward
wPMC_DMSN = 1.5; %2 weight between PMC neuron and any MSN
drgpe = 1.6; %2.0 %tonic drive to GPe neuron
wD2_GPe = 2.0*0.250; %*0.1 for HD 2.0 %weight of inhibitory connection from D2 MSN to GPe 
drstn = .80;%1.0 %tonic drive to the STN neuron DO NOT KNOW THIS VALUE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
wGPe_STN = 1.0; %*0.6 weight of inhibitory connection from GPe to STN
drgpi = 0.2; %0.2 %tonic drive to GPi neuron
wD1_GPi = .9; %1.4 weight of inhibitory connection from D1 MSN to GPi
wSTN_GPi = 1.6; %weight of excitatory connection from STN to GPi
l_r_PFC_D1 = 0.5; %0.5 learning rate between PFC neurons and D1 neurons
l_r_PFC_D2 = 0.25; %learning rate between PFC neurons and D2 neurons
d_r_PFC = 0.02; %degredation rate between PFC neurons and striatal neurons
nt = 5000; %number of timesteps 
n_trial = 500; %number of trials

whd=0.3;
wSTN_GPe=0.4;

%construction of neurons
pfc1 = PFC_neuron(0,t_constant,dt);
pfc2 = PFC_neuron(0,t_constant,dt);
pmc1 = PMC_neuron(0.1*rand,t_constant,dt,drm,wMinh,wPFC1_PMC1,wPFC2_PMC1,wgpi,learning_rate,decay_rate);
pmc2 = PMC_neuron(0.1*rand,t_constant,dt,drm,wMinh,wPFC1_PMC2,wPFC2_PMC2,wgpi,learning_rate,decay_rate);
snc1 = SNc_neuron(expected_reward1,alpha_SNc);
snc2 = SNc_neuron(expected_reward1,alpha_SNc);
d1msn1 = D1_MSN(0.1*rand,t_constant,dt,wPFC1_D1_1,wPFC2_D1_1,wPMC_DMSN,l_r_PFC_D1,d_r_PFC);
d1msn2 = D1_MSN(0.1*rand,t_constant,dt,wPFC1_D1_2,wPFC2_D1_2,wPMC_DMSN,l_r_PFC_D1,d_r_PFC);
d2msn1 = D2_MSN(0.1*rand,t_constant,dt,wPFC1_D2_1,wPFC2_D2_1,wPMC_DMSN,l_r_PFC_D2,d_r_PFC);
d2msn2 = D2_MSN(0.1*rand,t_constant,dt,wPFC1_D2_2,wPFC2_D2_2,wPMC_DMSN,l_r_PFC_D2,d_r_PFC);  
gpe1 = GPe_neuron(0.1*rand+0.6,t_constant,dt,drgpe,wD2_GPe,wSTN_GPe);
gpe2 = GPe_neuron(0.1*rand+0.6,t_constant,dt,drgpe,wD2_GPe,wSTN_GPe);
stn1 = STN_neuron(0.1*rand,t_constant,dt,drstn,wGPe_STN,whd);
stn2 = STN_neuron(0.1*rand,t_constant,dt,drstn,wGPe_STN,whd);
gpi1 = GPi_neuron(0.1*rand,t_constant,dt,drgpi,wD1_GPi,wSTN_GPi);
gpi2 = GPi_neuron(0.1*rand,t_constant,dt,drgpi,wD1_GPi,wSTN_GPi);  
PFC = {pfc1,pfc2};

%running of model
R_pfc1 = 1:nt; %vector of rates of pfc1 over nt dts
R_pfc2 = 1:nt; %vector of rates of pfc2 over nt dts
R_pmc1 = 1:nt; %vector of rates of pmc1 over nt dts
R_pmc2 = 1:nt; %vector of rates of pmc2 over nt dts
R_d1msn1 = 1:nt; %vector of rates of d1msn1 over nt dts
R_d1msn2 = 1:nt; %vector of rates of d1msn2 over nt dts
R_d2msn1 = 1:nt; %vector of rates of d2msn1 over nt dts
R_d2msn2 = 1:nt; %vector of rates of d2msn2 over nt dts
R_gpe1 = 1:nt; %vector of rates of gpe1 over nt dts
R_gpe2 = 1:nt; %vector of rates of gpe2 over nt dts
R_stn1 = 1:nt; %vector of rates of stn1 over nt dts
R_stn2 = 1:nt; %vector of rates of stn2 over nt dts
R_gpi1 = 1:nt; %vector of rates of gpi1 over nt dts
R_gpi2 = 1:nt; %vector of rates of gpi2 over nt dts
vwPFC1_PMC1 = 1:n_trial; %vector of weight between PFC1 and PMC1 over n_trial trials
vwPFC2_PMC1 = 1:n_trial; %vector of weight between PFC2 and PMC1 over n_trial trials
vwPFC1_PMC2 = 1:n_trial; %vector of weight between PFC1 and PMC2 over n_trial trials
vwPFC2_PMC2 = 1:n_trial; %vector of weight between PFC2 and PMC2 over n_trial trials
vR_pfc1 = 1:n_trial; %vector of equilibrium activity of PFC1 neuron at the end of trial
vR_pfc2 = 1:n_trial; %vector of equilibrium activity of PFC2 neuron at the end of trial
vR_pmc1 = 1:n_trial; %vector of equilibrium activity of PMC1 neuron at the end of trial
vR_pmc2 = 1:n_trial; %vector of equilibrium activity of PMC2 neuron at the end of trial
vwPFC1_D1_1 = 1:n_trial; %vector of weight between first PFC neuron and first D1 MSN
vwPFC2_D1_2 = 1:n_trial; %vector of weight between second PFC neuron and second D1 MSN
vwPFC1_D2_1 = 1:n_trial; %vector of weight between first PFC neuron and first D2 MSN
vwPFC2_D2_2 = 1:n_trial; %vector of weight between second PFC neuron and second D2 MSN
vwPFC2_D1_1 = 1:n_trial; %vector of weight between second PFC neuron and first D1 MSN
vwPFC2_D2_1 = 1:n_trial; %vector of weight between second PFC neuron and first D2 MSN
vwPFC1_D1_2 = 1:n_trial; %vector of weight between first PFC neuron and second D1 MSN
vwPFC1_D2_2 = 1:n_trial; %vector of weight between frist PFC neuron and second D2 MSN

for j = 1:n_trial

    for i = 1:nt
    R_pfc1(i)=pfc1.activity; R_pfc2(i)=pfc2.activity;
    R_pmc1(i)=pmc1.activity; R_pmc2(i)=pmc2.activity;
    R_d1msn1(i)=d1msn1.activity; R_d1msn2(i)=d1msn2.activity;
    R_d2msn1(i)=d2msn1.activity; R_d2msn2(i)=d2msn2.activity;
    R_gpe1(i)=gpe1.activity; R_gpe2(i)=gpe2.activity;
    R_stn1(i)=stn1.activity; R_stn2(i)=stn2.activity;
    R_gpi1(i)=gpi1.activity; R_gpi2(i)=gpi2.activity;
    
    pfc1 = pfc1.update_activity(input_pfc1);
    pfc2 = pfc2.update_activity(input_pfc2);
    %Action 1 Pathways
    d1msn1 = d1msn1.update_si(PFC,pmc1);
    d1msn1 = d1msn1.update_activity;
    d2msn1 = d2msn1.update_si(PFC,pmc1);
    d2msn1 = d2msn1.update_activity;
    gpe1 = gpe1.update_si(d2msn1,stn1);
    gpe1 = gpe1.update_activity;
    stn1 = stn1.update_si(gpe1,pmc1);
    stn1 = stn1.update_activity;
    gpi1 = gpi1.update_si(d1msn1,stn1);
    gpi1 = gpi1.update_activity;
    %Action 2 Pathways
    d1msn2 = d1msn2.update_si(PFC,pmc2);
    d1msn2 = d1msn2.update_activity;
    d2msn2 = d2msn2.update_si(PFC,pmc2);
    d2msn2 = d2msn2.update_activity;
    gpe2 = gpe2.update_si(d2msn2,stn2);
    gpe2 = gpe2.update_activity;
    stn2 = stn2.update_si(gpe2,pmc2);
    stn2 = stn2.update_activity;
    gpi2 = gpi2.update_si(d1msn2,stn2);
    gpi2 = gpi2.update_activity;
    %Returning to PMC
    pmc1 = pmc1.set_si(PFC,pmc2,gpi1);
    pmc2 = pmc2.set_si(PFC,pmc1,gpi2);
    pmc1 = pmc1.update_activity;
    pmc2 = pmc2.update_activity;
    end
    
    vwPFC1_D1_1(j)=d1msn1.wPFC1; vwPFC1_D2_1(j)=d2msn1.wPFC1;
    vwPFC2_D1_1(j)=d1msn1.wPFC2; vwPFC2_D2_1(j)=d2msn1.wPFC2;
    vwPFC1_D1_2(j)=d1msn2.wPFC1; vwPFC1_D2_2(j)=d2msn2.wPFC1;
    vwPFC2_D1_2(j)=d1msn2.wPFC2; vwPFC2_D2_2(j)=d2msn2.wPFC2;
    vwPFC1_PMC1(j)=pmc1.wPFC1; vwPFC2_PMC1(j)=pmc1.wPFC2;
    vwPFC1_PMC2(j)=pmc2.wPFC1; vwPFC2_PMC2(j)=pmc2.wPFC2;
    vR_pfc1(j)=R_pfc1(nt); vR_pfc2(j)=R_pfc2(nt);
    vR_pmc1(j)=R_pmc1(nt); vR_pmc2(j)=R_pmc2(nt);
    
    if j < trial_switch
        if input_pfc1 ~= 0
            actual_reward2 = 0.0;
            if pmc1.activity > pmc2.activity
                actual_reward1 = 1.0;
            else
                actual_reward1 = 0.0;
            end
        else
            actual_reward1 = 0.0;
            if pmc1.activity < pmc2.activity
                actual_reward2 = 1.0;
            else
                actual_reward2 = 0.0;
            end
        end
    else
        if input_pfc1 ~= 0
            actual_reward2 = 0.0;
            if pmc2.activity > pmc1.activity
                actual_reward1 = 1.0;
            else
                actual_reward1 = 0.0;
            end
        else
            actual_reward1 = 0.0;
            if pmc2.activity < pmc1.activity
                actual_reward2 = 1.0;
            else
                actual_reward2 = 0.0;
            end
        end
    end
    
    snc1 = snc1.set_signal(actual_reward1);
    snc2 = snc2.set_signal(actual_reward2);
    
    %if input_pfc1 ~= 0
        d1msn1 = d1msn1.update_wPFC1(PFC,snc1);
        d2msn1 = d2msn1.update_wPFC1(PFC,snc1);
        d1msn2 = d1msn2.update_wPFC1(PFC,snc1);
        d2msn2 = d2msn2.update_wPFC1(PFC,snc1);
        snc1 = snc1.update_e_reward(actual_reward1);
    %else
        d1msn1 = d1msn1.update_wPFC2(PFC,snc2);
        d2msn1 = d2msn1.update_wPFC2(PFC,snc2);
        d1msn2 = d1msn2.update_wPFC2(PFC,snc2);
        d2msn2 = d2msn2.update_wPFC2(PFC,snc2); 
        scn2 = snc2.update_e_reward(actual_reward2);
    %end
    
    pmc1 = pmc1.update_weights(PFC,input_pfc1);
    pmc2 = pmc2.update_weights(PFC,input_pfc1);
    
    %setting up for next trial
    pfc1.activity = 0; pfc2.activity = 0;
    pmc1.activity = 0.1*rand; pmc2.activity = 0.1*rand;
    d1msn1.activity= 0.1*rand; d1msn2.activity = 0.1*rand;
    d2msn1.activity = 0.1*rand; d2msn2.activity = 0.1*rand;
    gpe1.activity = 0.6+0.1*rand; gpe2.activity = 0.6+0.1*rand;
    stn1.activity = 0.1*rand; stn2.activity = 0.1*rand;
    gpi1.activity = 0.1*rand; gpi2.activity = 0.1*rand;
    
end
  
figure(1)
set(gca, 'DefaultAxesFontSize', 12)
subplot(3,1,1), plot(vR_pmc1,'Linewidth',1.25),title('End Activity of PMC neurons','FontSize', 12);hold on;
subplot(3,1,1), plot(vR_pmc2,'Linewidth',1.25);legend('PMC1','PMC2');xlabel('Trial number');
ylabel('Firing Rate');l1=line([200 200],[0 1],'Color',[0 0 0]);
set(get(get(l1(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
ax = gca; %ax.FontSize = 16;
subplot(3,1,2), plot(vwPFC1_D1_1,'Linewidth',1.25),title('Synaptic weights of PFC-Striatum Connections','FontSize', 12);
hold on;subplot(3,1,2), plot(vwPFC1_D1_2,'Linewidth',1.25);subplot(3,1,2), plot(vwPFC1_D2_1,'Linewidth',1.25);
subplot(3,1,2), plot(vwPFC1_D2_2,'Linewidth',1.25);legend('D1-MSN1','D1-MSN2','D2-MSN1','D2-MSN2');
xlabel('Trial number');ylabel('Synaptic Weight');l1=line([200 200],[0 2],'Color',[0 0 0]);
set(get(get(l1(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
ax = gca; %ax.FontSize = 16;
subplot(3,1,3), plot(vwPFC1_PMC1,'Linewidth',1.25),title('Synaptic weights of PFC-PMC connections','FontSize', 12);
hold on; subplot(3,1,3), plot(vwPFC1_PMC2,'Linewidth',1.25);legend('PFC-PMC1','PFC-PMC2');
xlabel('Trial number');ylabel('Synaptic Weight');l1=line([200 200],[0 0.08],'Color',[0 0 0]);
set(get(get(l1(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
ax = gca; %ax.FontSize = 16;
subplot(3,1,3), ylim([0 0.08]);
