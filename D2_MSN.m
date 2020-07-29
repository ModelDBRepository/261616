classdef D2_MSN < handle 
    %This is the class for D2 MSN neurons. These neurons are located in the
    %striatum and receive input from both the PFC and PMC. They then pass
    %the signal through the DIRECT pathway. 
    
    properties
      activity; %activity level of neuron
      t_constant; %time constant
      dt; %delta t
      wPFC1; %connection weight with PFC neuron 1
      wPFC2; %connection weight with PFC neuron 2
      wPMC; %connection weight with corresponding PMC neuron
      synaptic_input; %total synaptic input into neuron
      learning_rate; %learning rate of D2 neurons (=0.6)
      deg_rate; %degredation rate of synapses between PFC neurons and D2
    end
    
    methods
        %constructor
        function obj = D2_MSN(activity,t_constant,dt,wPFC1,wPFC2,wPMC,lr,dr)
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
            obj.wPFC1 = wPFC1;
            obj.wPFC2 = wPFC2;
            obj.wPMC= wPMC;
            %obj.synaptic_input = 0;
            obj.learning_rate = lr;
            obj.deg_rate = dr;
        end
        
        %these functions will change wPFCs according to dopamine reward
        function obj = update_wPFC1(obj,PFC,SNc)
%             if SNc.signal < 0
            obj.wPFC1 = obj.wPFC1 + (-1)*obj.learning_rate*SNc.signal*PFC{1}.activity...
                *obj.activity - obj.deg_rate*obj.wPFC1;
            
            if obj.wPFC1 < 0
                obj.wPFC1 = 0;
            end 
%             end
        end
        
        function obj = update_wPFC2(obj,PFC,SNc)
%             if SNc.signal < 0
            obj.wPFC2 = obj.wPFC2 + (-1)*obj.learning_rate*SNc.signal*PFC{2}.activity...
                *obj.activity - obj.deg_rate*obj.wPFC2;
            
            if obj.wPFC2 < 0
                obj.wPFC2 = 0;
            end
%             end
        end
        
        function obj = update_si(obj,PFC, PMC)
            %Calculates synaptic input to this D2 MSN neuron
            %   PUT in entire PFC and ONLY PMC_neuron corresponding to
            %   the same action as this D2 MSN neuron
            obj.synaptic_input = (obj.wPFC1)*(PFC{1}.activity)+...
                (obj.wPFC2)*(PFC{2}.activity)+(obj.wPMC)*(PMC.activity)+0.*rand;
        end
        
        function obj = update_activity(obj)
            %updates activity of this D2 MSN neuron using syanptic input
            if obj.synaptic_input <= 0
                obj.activity = obj.activity - ((obj.activity-0.1*rand)/...
                    obj.t_constant)*(obj.dt);
            else
                obj.activity = obj.activity + (tanh(obj.synaptic_input)...
                    +0.1*rand-obj.activity)*(1/obj.t_constant)*(obj.dt);
            end
        end
    end
end

