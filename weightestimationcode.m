clc; clear; close all;

fprintf("=============================================\n");
fprintf("   UAV MASS BUDGET CALCULATOR (VTOL FIXED WING)\n");
fprintf("=============================================\n\n");

%% ============================
% USER INPUTS (CALCULATOR STYLE)
% ============================

W_payload = input("Enter Payload mass (kg): ");

n_batt = input("Enter number of batteries: ");
W_batt = input("Enter mass of ONE battery (kg): ");

W_vtol_propulsion = input("Enter VTOL propulsion mass TOTAL (kg) (motors+ESC+props): ");
W_cruise_propulsion = input("Enter Cruise propulsion mass TOTAL (kg) (motor+ESC+prop): ");

W_avionics = input("Enter Avionics mass TOTAL (kg) (FC+GPS+telemetry+servos+wiring+power): ");

fprintf("\nStructural fraction f (Airframe/MTOW)\n");
fprintf("Typical: 0.20(light)  0.25(realistic)  0.30(heavy)\n");
f_structure = input("Enter structural fraction f (0 to 1): ");

%% ============================
% VALIDATION CHECKS
% ============================

if f_structure <= 0 || f_structure >= 1
    error("ERROR: f must be between 0 and 1 (example: 0.25).");
end

if n_batt < 0 || floor(n_batt) ~= n_batt
    error("ERROR: number of batteries must be a non-negative integer.");
end

inputs_vec = [W_payload, W_batt, W_vtol_propulsion, W_cruise_propulsion, W_avionics];
if any(inputs_vec < 0)
    error("ERROR: Mass values cannot be negative.");
end

%% ============================
% CALCULATIONS
% ============================

W_battery_total = n_batt * W_batt;

W_non_airframe = W_payload + W_battery_total + W_vtol_propulsion + W_cruise_propulsion + W_avionics;

W_MTOW = W_non_airframe / (1 - f_structure);

W_airframe = f_structure * W_MTOW;

W_check = W_non_airframe + W_airframe;

% Percent contributions
pct_payload  = (W_payload / W_MTOW) * 100;
pct_battery  = (W_battery_total / W_MTOW) * 100;
pct_vtol     = (W_vtol_propulsion / W_MTOW) * 100;
pct_cruise   = (W_cruise_propulsion / W_MTOW) * 100;
pct_avionics = (W_avionics / W_MTOW) * 100;
pct_airframe = (W_airframe / W_MTOW) * 100;

%% ============================
% OUTPUT RESULTS
% ============================

fprintf("\n=============================================\n");
fprintf("                 RESULTS\n");
fprintf("=============================================\n");

fprintf("Total battery mass                 = %.3f kg\n", W_battery_total);
fprintf("Non-airframe weight (W_non)        = %.3f kg\n", W_non_airframe);
fprintf("Estimated MTOW (W_MTOW)            = %.3f kg\n", W_MTOW);
fprintf("Estimated airframe weight          = %.3f kg\n", W_airframe);
fprintf("Check (W_non + W_airframe)         = %.3f kg\n", W_check);

fprintf("\n----------- % Contribution of MTOW -----------\n");
fprintf("Payload        = %6.2f %%\n", pct_payload);
fprintf("Batteries      = %6.2f %%\n", pct_battery);
fprintf("VTOL Propulsion= %6.2f %%\n", pct_vtol);
fprintf("Cruise Prop    = %6.2f %%\n", pct_cruise);
fprintf("Avionics       = %6.2f %%\n", pct_avionics);
fprintf("Airframe       = %6.2f %%\n", pct_airframe);

fprintf("\n=============================================\n");

%% ============================
% OPTIONAL SUMMARY TABLE
% ============================

Component = ["Payload"; "Batteries"; "VTOL Propulsion"; "Cruise Propulsion"; "Avionics"; "Airframe"; "TOTAL MTOW"];
Mass_kg   = [W_payload; W_battery_total; W_vtol_propulsion; W_cruise_propulsion; W_avionics; W_airframe; W_MTOW];
Percent   = [pct_payload; pct_battery; pct_vtol; pct_cruise; pct_avionics; pct_airframe; 100];

T = table(Component, Mass_kg, Percent);
disp(T);
