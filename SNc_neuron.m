classdef SNc_neuron < handle
    %Class for SNc, which returns reward signal
    
    properties
        e_reward; %expected reward for cue
        alpha; %constant used to update expected reward (=.15)
        signal; %reward/punishment signal from SNc
    end
    
    methods
        %constructor
        function obj = SNc_neuron(e_reward,alpha)
            obj.e_reward = e_reward;
            obj.alpha = alpha; 
            obj.signal = 0;
        end
        
        function obj = set_signal(obj,reward)
            %calculates signal sent from SNc due to perceived reward
            obj.signal = reward - obj.e_reward;
        end
        
        function obj = update_e_reward(obj,reward)
            %Updates expected reward given current reward
            obj.e_reward = (1-obj.alpha)*(obj.e_reward)+(obj.alpha)*reward;
        end
    end
end

