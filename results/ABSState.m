classdef ABSState
    %ABSSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SMacro
        SMicro
        nUEMacro
        nUEMicro
        nABS
        Reward
    end
    
    methods
        
        function obj = ABSState(Param, nTotSim)
            obj.SMacro = zeros(nTotSim, Param.numMacro);
            obj.SMicro = zeros(nTotSim, 1);
            obj.nUEMacro = zeros(nTotSim, Param.numMacro);
            obj.nUEMicro = zeros(nTotSim, 1);
            obj.nABS = zeros(nTotSim, 1);
            obj.Reward = zeros(nTotSim, 1);
        end
        
        function obj = recordState(obj, nSim, Stations, Param, SimulationMetrics)
            
            %indexes starts from 1
            nSim = nSim + 1;
            
            %get macro cell indexes
            macros = zeros(Param.numMacro);
            i = 1;
            for iStation = 1:length(Stations)
                if Stations(iStation).BsClass =='macro'
                    macros(i) = iStation;
                    i = i + 1;
                end 
            end
            %get throughput for macro cells
            obj.SMacro(nSim, 1:length(macros)) = sum(SimulationMetrics.txBits(:,macros), 1) * Param.schRounds * 10^-3;
            %get the number of active users
            [~, macroUsers] = find(SimulationMetrics.activeUsers(:, macros, :));
            obj.nUEMacro(nSim,1:length(macros)) = length(unique(macroUsers));
            
            %compute the average number of active users and throughput per
            %micro cell
            sTotMicro = 0;
            nTotUEMicro = 0;
            micros = setdiff(1:length(Stations), macros);
            for iMicro = micros 
                sTotMicro = sTotMicro + sum(SimulationMetrics.txBits(:,iMicro), 1);
                [~, microUsers] = find(SimulationMetrics.activeUsers(:, iMicro, :));
                nTotUEMicro = nTotUEMicro + length(unique(microUsers));
            end
            obj.SMicro(nSim)= (sTotMicro * Param.schRounds * 10^-3) / Param.numMicro;
            obj.nUEMicro(nSim) = nTotUEMicro /Param.numMicro;
        end
        
        function obj = recordNABS(obj, nSim, nABS)
            
            %indexes start from 1
            nSim = nSim + 1;
            
            obj.nABS(nSim) = nABS; 
        end
        
        function obj = recordReward(obj, nSim)
            %indexes start from 1
            nSim = nSim + 1;
            
            state.SMacro = obj.SMacro(nSim);
            state.SMicro = obj.SMicro(nSim);
            state.nUEMacro = obj.nUEMacro(nSim);
            state.nUEMicro = obj.nUEMicro(nSim);
            
            %reward refers to previous state
            obj.Reward(nSim - 1) = findReward(state);
        end
    end
    
end

