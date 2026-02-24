-- ============================================
-- REAL ESTATE SUPPORT TRIAGE AGENT
-- Complete Database with Sample Data
-- ============================================

-- Step 1: Create Database
DROP DATABASE IF EXISTS real_estate_triage;
CREATE DATABASE real_estate_triage;
USE real_estate_triage;


-- ============================================
-- Step 2: Create Tables
-- ============================================

-- Main tickets table
CREATE TABLE support_tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id VARCHAR(20) UNIQUE NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    sender_email VARCHAR(150) NOT NULL,
    property_name VARCHAR(100),
    unit_number VARCHAR(20),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    category VARCHAR(50) DEFAULT NULL,
    urgency ENUM('low', 'medium', 'high') DEFAULT NULL,
    status ENUM('open', 'in_progress', 'resolved', 'closed') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Extracted entities from NER
CREATE TABLE extracted_entities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id VARCHAR(20) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_value VARCHAR(255) NOT NULL,
    confidence FLOAT DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id)
);

-- LLM generated draft responses
CREATE TABLE draft_responses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id VARCHAR(20) NOT NULL,
    draft_text TEXT NOT NULL,
    model_used VARCHAR(50) DEFAULT NULL,
    approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id)
);

-- Action log for audit trail
CREATE TABLE triage_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id VARCHAR(20) NOT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id)
);


-- ============================================
-- Step 3: Insert Sample Data (100 Tickets)
-- ============================================

-- =============================================
-- CATEGORY: MAINTENANCE URGENT (20 tickets)
-- =============================================

INSERT INTO support_tickets (ticket_id, sender_name, sender_email, property_name, unit_number, subject, message, category, urgency, status, created_at) VALUES

('TKT-10001', 'John Smith', 'john.smith@gmail.com', 'Sunset Apartments', '5B-302',
'URGENT: Pipe Burst in Bathroom',
'Water is flooding my entire bathroom and spreading to the hallway in unit 5B-302. The pipe under the sink burst about 30 minutes ago. I have tried to stop it with towels but it is getting worse. Please send a plumber immediately!',
'maintenance_request', 'high', 'open', '2025-01-15 08:23:00'),

('TKT-10002', 'Sarah Johnson', 'sarah.johnson@yahoo.com', 'Oakwood Residences', '3A-105',
'EMERGENCY: Gas Smell in Kitchen',
'I can smell gas in my kitchen in unit 3A-105 since this morning. I have turned off all the burners but the smell is still there. I am very worried about safety. Please send someone immediately. I have opened all windows.',
'maintenance_request', 'high', 'open', '2025-01-15 09:45:00'),

('TKT-10003', 'Mike Davis', 'mike.davis@outlook.com', 'Maple Grove Complex', '8C-410',
'CRITICAL: No Heating in Winter',
'The heating system in unit 8C-410 completely stopped working last night. The temperature inside is below 45 degrees Fahrenheit. I have a 2 year old child and this is dangerous. We need emergency repair today!',
'maintenance_request', 'high', 'open', '2025-01-16 06:12:00'),

('TKT-10004', 'Emily Chen', 'emily.chen@gmail.com', 'Pine Valley Estates', '2D-208',
'URGENT: Electrical Sparks from Outlet',
'Sparks are coming from the electrical outlet in the living room of unit 2D-208. I heard a popping sound and saw blue sparks. I have unplugged everything and turned off the breaker. This is a fire hazard. Need an electrician ASAP!',
'maintenance_request', 'high', 'open', '2025-01-16 14:30:00'),

('TKT-10005', 'Robert Wilson', 'robert.wilson@hotmail.com', 'Riverdale Heights', '10A-601',
'EMERGENCY: Ceiling Collapse',
'A section of the ceiling in my bedroom in unit 10A-601 just collapsed. There is debris everywhere and I can see water damage above. I think there is a leak from the unit above me. This is extremely dangerous. Please send help now!',
'maintenance_request', 'high', 'open', '2025-01-17 03:15:00'),

('TKT-10006', 'Lisa Anderson', 'lisa.anderson@gmail.com', 'Cedar Point Towers', '7B-515',
'URGENT: Carbon Monoxide Detector Beeping',
'The carbon monoxide detector in unit 7B-515 has been beeping continuously for the past hour. I am not sure if there is an actual CO leak or if the detector is faulty. Either way I am scared. I have moved to the hallway with my kids. Please send someone!',
'maintenance_request', 'high', 'open', '2025-01-17 11:20:00'),

('TKT-10007', 'David Martinez', 'david.martinez@yahoo.com', 'Lakeside Villas', '1C-102',
'CRITICAL: Front Door Lock Broken',
'The lock on my front door in unit 1C-102 is completely broken. I cannot lock my apartment at all. Someone tried to force it open last night. I do not feel safe. I need a locksmith today. This is a security emergency!',
'maintenance_request', 'high', 'open', '2025-01-17 19:45:00'),

('TKT-10008', 'Jennifer Taylor', 'jennifer.taylor@icloud.com', 'Harmony Gardens', '4A-305',
'URGENT: Toilet Overflowing Non Stop',
'The toilet in the main bathroom of unit 4A-305 is overflowing continuously. Water is all over the bathroom floor and starting to seep into the bedroom carpet. I have tried plunging but nothing works. Emergency plumber needed!',
'maintenance_request', 'high', 'open', '2025-01-18 07:30:00'),

('TKT-10009', 'James Brown', 'james.brown@gmail.com', 'Silver Creek Apartments', '6B-412',
'EMERGENCY: Smoke from Electrical Panel',
'I see smoke coming from the electrical panel in the hallway near unit 6B-412. There is a burning smell getting stronger. I have alerted my neighbors. Please send emergency maintenance and fire department if needed!',
'maintenance_request', 'high', 'open', '2025-01-18 22:10:00'),

('TKT-10010', 'Maria Garcia', 'maria.garcia@outlook.com', 'Greenfield Residences', '9D-703',
'URGENT: Window Shattered During Storm',
'The bedroom window in unit 9D-703 shattered during the storm tonight. Rain and wind are coming in. Glass is everywhere on the floor. I have covered it with cardboard but it is not holding. Need emergency repair. I have a baby sleeping in the next room.',
'maintenance_request', 'high', 'open', '2025-01-19 01:45:00'),

('TKT-10011', 'William Lee', 'william.lee@gmail.com', 'Sunset Apartments', '3C-201',
'CRITICAL: Water Heater Leaking Gas',
'The water heater in unit 3C-201 closet is making a hissing sound and I can smell gas around it. I have shut off the gas valve but I am not sure if it is fully closed. This started about an hour ago. Very worried about explosion risk.',
'maintenance_request', 'high', 'open', '2025-01-19 10:30:00'),

('TKT-10012', 'Amanda White', 'amanda.white@yahoo.com', 'Oakwood Residences', '5A-408',
'URGENT: Sewage Backup in Bathroom',
'Raw sewage is coming up through the bathtub drain in unit 5A-408. The smell is terrible and it is a health hazard. Brown water is filling the tub and I cannot stop it. My children cannot use the bathroom. Need emergency plumbing now!',
'maintenance_request', 'high', 'open', '2025-01-19 15:20:00'),

('TKT-10013', 'Christopher Harris', 'chris.harris@hotmail.com', 'Maple Grove Complex', '2B-110',
'EMERGENCY: Ceiling Fan Fell Down',
'The ceiling fan in the living room of unit 2B-110 just fell from the ceiling while it was running. It almost hit my daughter. The wires are exposed and hanging from the ceiling. This is extremely dangerous. Need immediate repair!',
'maintenance_request', 'high', 'open', '2025-01-20 08:15:00'),

('TKT-10014', 'Jessica Thompson', 'jessica.t@gmail.com', 'Pine Valley Estates', '11A-502',
'URGENT: Flooding from Above Unit',
'Water is pouring through my ceiling in unit 11A-502. It seems like the apartment above has a major leak. My furniture is getting damaged. Water is near the electrical outlets which is very dangerous. Please help immediately!',
'maintenance_request', 'high', 'open', '2025-01-20 13:40:00'),

('TKT-10015', 'Daniel Robinson', 'daniel.robinson@icloud.com', 'Riverdale Heights', '8B-315',
'CRITICAL: AC Unit on Fire',
'My window AC unit in unit 8B-315 started smoking and I saw small flames coming from the back. I immediately unplugged it and moved away. The wall behind it looks scorched. I need someone to inspect this right away and check the wiring.',
'maintenance_request', 'high', 'open', '2025-01-20 16:55:00'),

('TKT-10016', 'Ashley Clark', 'ashley.clark@gmail.com', 'Cedar Point Towers', '1A-101',
'URGENT: Elevator Stuck With People Inside',
'The elevator in Building A is stuck between floors 3 and 4. There are people trapped inside including an elderly woman. We can hear them calling for help. The emergency button does not seem to be working. Unit 1A-101 resident reporting.',
'maintenance_request', 'high', 'open', '2025-01-21 09:00:00'),

('TKT-10017', 'Matthew Lewis', 'matt.lewis@yahoo.com', 'Lakeside Villas', '6C-420',
'EMERGENCY: Major Roof Leak',
'There is a massive leak in the roof above unit 6C-420. Water is pouring in through multiple spots in the ceiling. Buckets are overflowing within minutes. My electronics and furniture are getting destroyed. Need immediate tarping and repair!',
'maintenance_request', 'high', 'open', '2025-01-21 04:30:00'),

('TKT-10018', 'Stephanie Walker', 'steph.walker@outlook.com', 'Harmony Gardens', '12D-801',
'URGENT: Balcony Railing Loose',
'The balcony railing in unit 12D-801 on the 8th floor is extremely loose and wobbling. I am afraid it might fall off. This is a serious safety hazard especially since children play in the area below. Please fix this before someone gets hurt!',
'maintenance_request', 'high', 'open', '2025-01-21 11:15:00'),

('TKT-10019', 'Andrew Hall', 'andrew.hall@gmail.com', 'Silver Creek Apartments', '4D-309',
'CRITICAL: Stove Wont Turn Off',
'The electric stove in unit 4D-309 will not turn off. I have turned all knobs to off position but one burner stays on at full heat. I cannot unplug it because it is hardwired. The kitchen is getting extremely hot. Fire risk! Need electrician immediately!',
'maintenance_request', 'high', 'open', '2025-01-22 07:00:00'),

('TKT-10020', 'Nicole Allen', 'nicole.allen@hotmail.com', 'Greenfield Residences', '7A-510',
'URGENT: Mold Found Behind Wall',
'We discovered extensive black mold behind the bathroom wall in unit 7A-510 when the towel rack fell off. The entire wall behind seems covered in mold. My son has asthma and has been having breathing problems for weeks. This is a health emergency!',
'maintenance_request', 'high', 'open', '2025-01-22 14:30:00'),


-- =============================================
-- CATEGORY: MAINTENANCE NORMAL (20 tickets)
-- =============================================

('TKT-10021', 'Ryan King', 'ryan.king@gmail.com', 'Sunset Apartments', '2A-204',
'Maintenance Request: Dripping Faucet',
'The kitchen faucet in unit 2A-204 has been dripping slowly for about a week now. It is not an emergency but the constant dripping sound is annoying and I am worried about the water bill. Could you send someone to fix it when convenient?',
'maintenance_request', 'medium', 'open', '2025-01-15 10:00:00'),

('TKT-10022', 'Megan Wright', 'megan.wright@yahoo.com', 'Oakwood Residences', '4B-312',
'Repair Needed: Dishwasher Not Draining',
'The dishwasher in unit 4B-312 is not draining properly after the wash cycle. There is standing water at the bottom after every use. I have cleaned the filter but it did not help. Would like to schedule a repair at your convenience.',
'maintenance_request', 'medium', 'open', '2025-01-15 14:20:00'),

('TKT-10023', 'Joshua Scott', 'josh.scott@outlook.com', 'Maple Grove Complex', '6A-415',
'Hallway Light Burned Out',
'The hallway light outside unit 6A-415 has been out for over a week now. It gets very dark at night and I almost tripped yesterday. Could maintenance please replace the bulb? Thank you.',
'maintenance_request', 'low', 'open', '2025-01-16 09:30:00'),

('TKT-10024', 'Rachel Green', 'rachel.green@gmail.com', 'Pine Valley Estates', '3C-207',
'Paint Peeling in Bathroom',
'The paint on the bathroom ceiling in unit 3C-207 is peeling badly. It started as a small spot but now a large area is affected. I think there might be moisture causing it. Not urgent but would like it fixed soon.',
'maintenance_request', 'medium', 'open', '2025-01-16 16:45:00'),

('TKT-10025', 'Kevin Adams', 'kevin.adams@icloud.com', 'Riverdale Heights', '9B-605',
'Window Screen Torn',
'The window screen in the bedroom of unit 9B-605 has a large tear in it. Bugs and mosquitoes are getting in at night. Could you please have it replaced? I am available most afternoons for the repair.',
'maintenance_request', 'low', 'open', '2025-01-17 08:00:00'),

('TKT-10026', 'Laura Nelson', 'laura.nelson@gmail.com', 'Cedar Point Towers', '5C-401',
'Cabinet Door Hinge Broken',
'One of the kitchen cabinet door hinges in unit 5C-401 is broken. The door keeps swinging open and will not stay closed. It is the upper cabinet next to the refrigerator. Please send someone to fix it.',
'maintenance_request', 'low', 'open', '2025-01-17 12:15:00'),

('TKT-10027', 'Brian Hill', 'brian.hill@yahoo.com', 'Lakeside Villas', '8A-520',
'Garbage Disposal Jammed',
'The garbage disposal in unit 8A-520 is making a humming noise but not working. I think something is jammed inside. I tried the reset button but no luck. Would appreciate a maintenance visit when possible.',
'maintenance_request', 'medium', 'open', '2025-01-18 10:30:00'),

('TKT-10028', 'Samantha Moore', 'sam.moore@hotmail.com', 'Harmony Gardens', '1B-103',
'Carpet Stain in Living Room',
'There is a large stain on the carpet in the living room of unit 1B-103. It was there when I moved in last month. I reported it during move-in inspection. Could you schedule a professional carpet cleaning?',
'maintenance_request', 'low', 'open', '2025-01-18 15:00:00'),

('TKT-10029', 'Justin Baker', 'justin.baker@gmail.com', 'Silver Creek Apartments', '7C-418',
'Noisy Bathroom Exhaust Fan',
'The bathroom exhaust fan in unit 7C-418 is extremely noisy when turned on. It sounds like something is loose inside. It still works but the noise is very loud and bothers us at night. Please have it checked.',
'maintenance_request', 'low', 'open', '2025-01-19 09:45:00'),

('TKT-10030', 'Kayla Rivera', 'kayla.rivera@outlook.com', 'Greenfield Residences', '10C-702',
'Closet Door Off Track',
'The sliding closet door in the master bedroom of unit 10C-702 has come off its track. I cannot open or close it properly. I tried to fix it myself but the track seems bent. Need maintenance help.',
'maintenance_request', 'low', 'open', '2025-01-19 13:20:00'),

('TKT-10031', 'Brandon Mitchell', 'brandon.m@gmail.com', 'Sunset Apartments', '11B-604',
'Slow Drain in Bathtub',
'The bathtub in unit 11B-604 is draining very slowly. It takes about 30 minutes for the water to fully drain after a shower. I have tried using drain cleaner but it only helped a little. Please schedule a maintenance visit.',
'maintenance_request', 'medium', 'open', '2025-01-20 08:30:00'),

('TKT-10032', 'Tiffany Campbell', 'tiffany.c@yahoo.com', 'Oakwood Residences', '2C-211',
'Refrigerator Making Loud Noise',
'The refrigerator in unit 2C-211 has started making a loud buzzing and clicking noise. It still keeps food cold but the noise is constant and very annoying especially at night. Could someone take a look?',
'maintenance_request', 'medium', 'open', '2025-01-20 11:00:00'),

('TKT-10033', 'Marcus Johnson', 'marcus.j@gmail.com', 'Maple Grove Complex', '4A-310',
'Weatherstripping Needed on Front Door',
'There is a visible gap under the front door of unit 4A-310. I can feel cold air coming in and it is affecting the heating efficiency. The weatherstripping seems worn out. Could you have it replaced?',
'maintenance_request', 'low', 'open', '2025-01-21 07:15:00'),

('TKT-10034', 'Diana Ross', 'diana.ross@hotmail.com', 'Pine Valley Estates', '6D-425',
'Towel Rack Fell Off Wall',
'The towel rack in the bathroom of unit 6D-425 pulled out of the wall. The drywall anchors seem to have failed. There are holes in the wall now. I need it remounted properly with better anchors.',
'maintenance_request', 'low', 'open', '2025-01-21 14:45:00'),

('TKT-10035', 'Thomas Wright', 'thomas.w@icloud.com', 'Riverdale Heights', '12A-805',
'Microwave Not Heating',
'The built-in microwave in unit 12A-805 runs and the turntable spins but it does not heat food at all. It was working fine last week. Since it is a built-in unit that came with the apartment I assume it is your responsibility to fix.',
'maintenance_request', 'medium', 'open', '2025-01-22 09:00:00'),

('TKT-10036', 'Hannah Baker', 'hannah.b@gmail.com', 'Cedar Point Towers', '8D-530',
'Squeaky Floor in Bedroom',
'The floor in the bedroom of unit 8D-530 has developed a very loud squeak near the closet area. Every time I walk there it makes noise. My downstairs neighbor has also complained about the sound.',
'maintenance_request', 'low', 'open', '2025-01-22 12:30:00'),

('TKT-10037', 'George Parker', 'george.p@yahoo.com', 'Lakeside Villas', '3B-215',
'Patio Door Difficult to Open',
'The sliding patio door in unit 3B-215 is very hard to open and close. It feels like the rollers are worn out. I have to use a lot of force to move it. It has been getting worse over the past month.',
'maintenance_request', 'medium', 'open', '2025-01-23 08:00:00'),

('TKT-10038', 'Olivia Turner', 'olivia.t@outlook.com', 'Harmony Gardens', '9A-610',
'Dryer Taking Too Long to Dry',
'The dryer in unit 9A-610 is taking 2 to 3 cycles to dry a normal load of laundry. I have cleaned the lint trap but it still takes forever. I think the vent might be clogged. Please have maintenance check it.',
'maintenance_request', 'medium', 'open', '2025-01-23 11:30:00'),

('TKT-10039', 'Nathan Cooper', 'nathan.c@gmail.com', 'Silver Creek Apartments', '5D-404',
'Doorbell Not Working',
'The doorbell for unit 5D-404 stopped working about two weeks ago. Visitors have to knock or call me to get in. I have tried replacing the battery but it did not help. Might be a wiring issue.',
'maintenance_request', 'low', 'open', '2025-01-23 15:00:00'),

('TKT-10040', 'Sophie Martinez', 'sophie.m@hotmail.com', 'Greenfield Residences', '11C-715',
'Blinds Broken in Living Room',
'Two sets of blinds in the living room of unit 11C-715 are broken. The strings are tangled and the slats are bent. They do not open or close properly. I need them replaced as I have no privacy without them.',
'maintenance_request', 'medium', 'open', '2025-01-24 08:45:00'),


-- =============================================
-- CATEGORY: LEASE INQUIRY (20 tickets)
-- =============================================

('TKT-10041', 'Patricia Moore', 'patricia.m@gmail.com', 'Sunset Apartments', '4B-308',
'Lease Renewal Options',
'Hi, I would like to know about lease renewal options for unit 4B-308. My current lease ends on 03/31/2025 and I would like to continue staying. What are the new terms and is there any rent increase? Please let me know the process.',
'lease_inquiry', 'medium', 'open', '2025-01-15 11:00:00'),

('TKT-10042', 'Charles Evans', 'charles.e@yahoo.com', 'Oakwood Residences', '7A-501',
'Available 2 Bedroom Units',
'I am interested in renting a 2 bedroom apartment at Oakwood Residences starting 04/01/2025. Could you let me know what units are available and their monthly rent? I currently live in a 1 bedroom unit 7A-501 and want to upgrade.',
'lease_inquiry', 'medium', 'open', '2025-01-16 10:15:00'),

('TKT-10043', 'Victoria James', 'victoria.j@outlook.com', 'Maple Grove Complex', '5C-402',
'Request Copy of Lease Agreement',
'Can I get a copy of my current lease agreement for unit 5C-402? I need it for documentation purposes for a bank loan application. A digital copy sent to my email would be perfect. Thank you.',
'lease_inquiry', 'low', 'open', '2025-01-16 14:30:00'),

('TKT-10044', 'Peter Young', 'peter.young@gmail.com', 'Pine Valley Estates', '8B-520',
'Early Lease Termination Terms',
'What are the terms and penalties for early lease termination for unit 8B-520? I may need to relocate for work by 05/15/2025. My lease does not end until 09/30/2025. I want to understand my options and any fees involved.',
'lease_inquiry', 'medium', 'open', '2025-01-17 09:00:00'),

('TKT-10045', 'Rebecca Thomas', 'rebecca.t@icloud.com', 'Riverdale Heights', '2C-210',
'Adding Someone to Lease',
'I would like to add my partner to the lease for unit 2C-210. What paperwork is needed? Does my partner need to pass a background check? Will there be any change in rent or deposit? Please guide me through the process.',
'lease_inquiry', 'medium', 'open', '2025-01-17 13:45:00'),

('TKT-10046', 'Edward King', 'edward.king@gmail.com', 'Cedar Point Towers', '10B-620',
'Switch to Month to Month Lease',
'Is it possible to switch from my current 12 month lease to a month to month arrangement for unit 10B-620? My lease ends 02/28/2025 and I am not sure how long I will be staying. What would the monthly rate be?',
'lease_inquiry', 'medium', 'open', '2025-01-18 08:30:00'),

('TKT-10047', 'Michelle Scott', 'michelle.s@yahoo.com', 'Lakeside Villas', '6A-418',
'Pet Deposit Policy Question',
'I am thinking about getting a dog and I live in unit 6A-418. What is your pet policy? Is there a pet deposit required? Are there breed or weight restrictions? Also do you charge monthly pet rent? Please share all the details.',
'lease_inquiry', 'low', 'open', '2025-01-18 12:00:00'),

('TKT-10048', 'Frank Wilson', 'frank.wilson@hotmail.com', 'Harmony Gardens', '3D-220',
'Subletting My Apartment',
'I need to travel for work for 3 months starting 04/01/2025. Is it possible to sublet my unit 3D-220 during that time? What is the process and do you need to approve the subtenant? My lease runs through 12/31/2025.',
'lease_inquiry', 'medium', 'open', '2025-01-19 10:30:00'),

('TKT-10049', 'Catherine Brown', 'catherine.b@gmail.com', 'Silver Creek Apartments', '1A-106',
'Rent Escalation Clause Question',
'Can you please explain the rent escalation clause in my lease for unit 1A-106? I see a mention of annual increases but the percentage is not clear to me. I want to understand how much my rent might go up at renewal.',
'lease_inquiry', 'low', 'open', '2025-01-19 15:15:00'),

('TKT-10050', 'Steven Garcia', 'steven.g@outlook.com', 'Greenfield Residences', '12B-810',
'Move Out Procedures',
'I am planning to move out of unit 12B-810 when my lease ends on 06/30/2025. What are the move out procedures? How much notice do I need to give? What are the requirements for getting my security deposit back? Please provide a checklist.',
'lease_inquiry', 'medium', 'open', '2025-01-20 09:00:00'),

('TKT-10051', 'Angela Davis', 'angela.d@gmail.com', 'Sunset Apartments', '9C-615',
'Lease Transfer to Another Unit',
'I currently live in unit 9C-615 but would like to transfer to a larger unit in the same building. Is it possible to transfer my lease? Would I need to sign a new lease or can the existing one be amended?',
'lease_inquiry', 'medium', 'open', '2025-01-20 14:30:00'),

('TKT-10052', 'Raymond Lee', 'raymond.lee@yahoo.com', 'Oakwood Residences', '11A-708',
'Parking Space Included in Lease',
'I want to clarify if a parking space is included in my lease for unit 11A-708. When I signed the lease I was told one spot would be included but I have not been assigned one yet. My move in date was 01/01/2025.',
'lease_inquiry', 'medium', 'open', '2025-01-21 08:00:00'),

('TKT-10053', 'Donna Martinez', 'donna.m@icloud.com', 'Maple Grove Complex', '7D-505',
'Guest Stay Duration Policy',
'What is the policy on having guests stay overnight in unit 7D-505? My parents want to visit for 3 weeks. Is there a maximum number of consecutive days a guest can stay? Do I need to inform management?',
'lease_inquiry', 'low', 'open', '2025-01-21 11:30:00'),

('TKT-10054', 'Carl Thompson', 'carl.t@gmail.com', 'Pine Valley Estates', '4C-315',
'Home Office Modifications',
'I work from home full time in unit 4C-315. I would like to install a standing desk that needs to be bolted to the wall and add some cable management hooks. Does my lease allow these modifications? Do I need written permission?',
'lease_inquiry', 'low', 'open', '2025-01-22 10:00:00'),

('TKT-10055', 'Janet Robinson', 'janet.r@hotmail.com', 'Riverdale Heights', '6B-430',
'Lease Guarantor Removal',
'My parents were listed as guarantors on my lease for unit 6B-430 when I first moved in as a student. I now have a full time job with stable income. Can I have the guarantor removed from my lease? What documentation do you need?',
'lease_inquiry', 'low', 'open', '2025-01-22 14:00:00'),

('TKT-10056', 'Larry Anderson', 'larry.a@gmail.com', 'Cedar Point Towers', '2A-205',
'Rent Increase Notice Question',
'I received a notice about a rent increase for unit 2A-205 effective 04/01/2025. The increase is 8 percent which seems very high. Is this negotiable? My lease says increases should be reasonable. I have been a good tenant for 3 years.',
'lease_inquiry', 'medium', 'open', '2025-01-23 09:30:00'),

('TKT-10057', 'Sandra Clark', 'sandra.c@yahoo.com', 'Lakeside Villas', '5A-410',
'Lease Start Date Change',
'I recently signed a lease for unit 5A-410 starting 03/01/2025. Due to a delay in my current apartment move out, I need to change the start date to 03/15/2025. Is this possible? The lease has not started yet.',
'lease_inquiry', 'medium', 'open', '2025-01-23 13:00:00'),

('TKT-10058', 'Kenneth White', 'kenneth.w@outlook.com', 'Harmony Gardens', '8C-535',
'Storage Unit Availability',
'Are there any storage units available for rent at Harmony Gardens? I live in unit 8C-535 and need extra storage for seasonal items. What sizes are available and what is the monthly cost? Can it be added to my lease?',
'lease_inquiry', 'low', 'open', '2025-01-24 08:00:00'),

('TKT-10059', 'Dorothy Hall', 'dorothy.h@gmail.com', 'Silver Creek Apartments', '10D-640',
'Roommate Removal from Lease',
'My roommate is moving out of unit 10D-640 on 02/28/2025. I want to continue living here alone. What is the process to remove them from the lease? Will I need to qualify for the apartment on my own income?',
'lease_inquiry', 'medium', 'open', '2025-01-24 11:30:00'),

('TKT-10060', 'Paul Nelson', 'paul.nelson@hotmail.com', 'Greenfield Residences', '3A-215',
'Commercial Use of Apartment',
'I run a small online business from unit 3A-215. I do not have customers visiting but I do receive about 5 packages per day for my business. Does my lease prohibit commercial activity? I want to make sure I am not violating any terms.',
'lease_inquiry', 'low', 'open', '2025-01-25 09:00:00'),


-- =============================================
-- CATEGORY: PAYMENT ISSUE (15 tickets)
-- =============================================

('TKT-10061', 'Barbara Lewis', 'barbara.l@gmail.com', 'Sunset Apartments', '7C-512',
'Double Charged for Rent',
'I was charged twice for January rent for unit 7C-512. My bank shows two deductions of $1850 each on 01/01/2025 and 01/02/2025. Transaction IDs are TXN-445566 and TXN-445567. Please refund the duplicate charge immediately.',
'payment_issue', 'high', 'open', '2025-01-15 08:00:00'),

('TKT-10062', 'Mark Turner', 'mark.turner@yahoo.com', 'Oakwood Residences', '9A-608',
'Rent Payment Failed Need Extension',
'My rent payment for unit 9A-608 failed this month due to a bank issue. My account was temporarily frozen because of a fraud alert. It is resolved now. Can I get an extension until 01/20/2025 to pay without a late fee?',
'payment_issue', 'high', 'open', '2025-01-16 09:30:00'),

('TKT-10063', 'Susan Adams', 'susan.adams@outlook.com', 'Maple Grove Complex', '1D-108',
'Security Deposit Refund Not Received',
'I moved out of unit 1D-108 on 12/01/2024 and still have not received my security deposit refund. It has been over 45 days. My forwarding address is 456 Oak Street Apt 2. The deposit was $2400. Please process this immediately.',
'payment_issue', 'high', 'open', '2025-01-17 10:15:00'),

('TKT-10064', 'Richard Baker', 'richard.b@gmail.com', 'Pine Valley Estates', '12C-730',
'Incorrect Late Fee on Account',
'There is a late fee of $75 on my account for unit 12C-730 but I paid my rent on time. My payment confirmation is PAY-889900 dated 01/01/2025. The online portal shows it was received on 01/01/2025. Please remove the late fee.',
'payment_issue', 'high', 'open', '2025-01-17 14:00:00'),

('TKT-10065', 'Carol Wright', 'carol.wright@icloud.com', 'Riverdale Heights', '4A-302',
'Setup Autopay for Rent',
'I would like to set up automatic monthly rent payments for unit 4A-302. What payment methods do you accept for autopay? Can I use a credit card or does it have to be a bank account? Please send me the enrollment form.',
'payment_issue', 'medium', 'open', '2025-01-18 11:00:00'),

('TKT-10066', 'Joseph Hill', 'joseph.hill@hotmail.com', 'Cedar Point Towers', '6D-440',
'Financial Hardship Payment Plan Request',
'I recently lost my job and I am having difficulty paying rent for unit 6D-440. I have been a tenant for 4 years and never missed a payment before. Can we discuss a temporary payment plan for the next 2 to 3 months until I find new employment?',
'payment_issue', 'high', 'open', '2025-01-19 08:30:00'),

('TKT-10067', 'Karen Mitchell', 'karen.m@gmail.com', 'Lakeside Villas', '10A-625',
'Payment Not Showing on Portal',
'I made my rent payment for unit 10A-625 on 01/01/2025 via bank transfer. The money has left my account but the online portal still shows my balance as unpaid. My bank confirmation number is PAY-112233. Please update my account.',
'payment_issue', 'medium', 'open', '2025-01-19 12:45:00'),

('TKT-10068', 'George Campbell', 'george.c@yahoo.com', 'Harmony Gardens', '5B-406',
'Unexpected Rent Increase',
'My rent for unit 5B-406 increased from $1650 to $1800 this month but I did not receive any prior notice about the increase. My lease says 30 days written notice is required for rent changes. I would like clarification on this.',
'payment_issue', 'high', 'open', '2025-01-20 09:15:00'),

('TKT-10069', 'Betty Rivera', 'betty.r@outlook.com', 'Silver Creek Apartments', '3C-218',
'Payment Receipts for Tax Purposes',
'I need receipts for all rent payments made for unit 3C-218 during the year 2024 for my tax filing. Can you please send me a yearly statement showing all 12 monthly payments and any other charges? I need it before 02/15/2025.',
'payment_issue', 'medium', 'open', '2025-01-20 14:30:00'),

('TKT-10070', 'Dennis Parker', 'dennis.p@gmail.com', 'Greenfield Residences', '8A-545',
'Maintenance Fee Discrepancy',
'The maintenance fee for unit 8A-545 this month is $150 but my lease states it should be $100 per month. I was charged an extra $50 with no explanation. Please clarify why the increase and adjust if it is an error. Reference: PAY-334455.',
'payment_issue', 'medium', 'open', '2025-01-21 10:00:00'),

('TKT-10071', 'Sharon Cooper', 'sharon.c@yahoo.com', 'Sunset Apartments', '11D-710',
'Refund for Amenity Fee',
'I have been paying a $50 monthly amenity fee for pool and gym access for unit 11D-710. The pool has been closed for 3 months for renovation and the gym was closed for 2 weeks. I would like a partial refund for the months these amenities were unavailable.',
'payment_issue', 'medium', 'open', '2025-01-21 13:30:00'),

('TKT-10072', 'Timothy Ross', 'timothy.r@hotmail.com', 'Oakwood Residences', '6C-435',
'Check Payment Lost in Mail',
'I mailed a check for January rent for unit 6C-435 on 12/28/2024 but it seems to have been lost in the mail. The check number is 4521 for $1700. Can I put a stop payment on the check and pay electronically instead? Will there be a late fee?',
'payment_issue', 'high', 'open', '2025-01-22 08:00:00'),

('TKT-10073', 'Deborah Evans', 'deborah.e@gmail.com', 'Maple Grove Complex', '2D-212',
'Utility Bill Seems Too High',
'The utility bill for unit 2D-212 this month is $380 which is almost double my usual amount. I have not changed my usage habits. Could there be a meter reading error? I would like someone to verify the meter reading for my unit.',
'payment_issue', 'medium', 'open', '2025-01-22 11:45:00'),

('TKT-10074', 'Jason Young', 'jason.young@icloud.com', 'Pine Valley Estates', '9D-620',
'Pro-rated Rent Calculation Question',
'I am moving into unit 9D-620 on 01/15/2025 in the middle of the month. How is the pro-rated rent calculated? My monthly rent is $2100. Should I pay for 16 days or 17 days of January? When is this first payment due?',
'payment_issue', 'medium', 'open', '2025-01-23 10:00:00'),

('TKT-10075', 'Laura Thomas', 'laura.t@gmail.com', 'Riverdale Heights', '7B-508',
'Parking Fee Added Without Notice',
'A parking fee of $75 was added to my January bill for unit 7B-508. I have always had free parking included in my lease. No one informed me about this new charge. Please remove it or explain why it was added. Reference: PAY-556677.',
'payment_issue', 'high', 'open', '2025-01-23 14:30:00'),


-- =============================================
-- CATEGORY: COMPLAINT (15 tickets)
-- =============================================

('TKT-10076', 'Henry Jackson', 'henry.j@gmail.com', 'Sunset Apartments', '4C-310',
'Noise Complaint Against Neighbor',
'The tenant in unit 4C-311 next to my unit 4C-310 plays extremely loud music every night from 11 PM to 2 AM. I have asked them politely to lower the volume but nothing has changed. This has been going on for 3 weeks. I cannot sleep. Please intervene.',
'complaint', 'medium', 'open', '2025-01-15 23:30:00'),

('TKT-10077', 'Virginia Martin', 'virginia.m@yahoo.com', 'Oakwood Residences', '8B-525',
'Pest Problem in Apartment',
'I have been seeing cockroaches in my kitchen in unit 8B-525 almost every day for the past 2 weeks. I keep my apartment very clean so I think they are coming from somewhere else in the building. Please send pest control immediately.',
'complaint', 'medium', 'open', '2025-01-16 07:00:00'),

('TKT-10078', 'Eugene Harris', 'eugene.h@outlook.com', 'Maple Grove Complex', '1A-104',
'Parking Lot Lights Out Unsafe',
'The parking lot lights on the south side of Maple Grove Complex have been out for over 2 weeks now. It is completely dark at night and I feel very unsafe walking to my car. I am in unit 1A-104. This is a safety concern that needs immediate attention.',
'complaint', 'medium', 'open', '2025-01-17 18:00:00'),

('TKT-10079', 'Ruth Clark', 'ruth.clark@gmail.com', 'Pine Valley Estates', '5D-415',
'Construction Noise Complaint',
'The renovation happening in unit 5D-416 next to my unit 5D-415 is extremely loud and starts at 7 AM every morning including weekends. I work from home and cannot take phone calls. How long will this construction last? Can they start later?',
'complaint', 'medium', 'open', '2025-01-18 09:00:00'),

('TKT-10080', 'Albert Lewis', 'albert.l@hotmail.com', 'Riverdale Heights', '12C-812',
'Elevator Out of Service Too Long',
'The elevator in Building C at Riverdale Heights has been out of service for 5 days now with no update on when it will be fixed. I live on the 8th floor in unit 12C-812 and I have a knee injury. Climbing stairs is extremely painful. When will it be fixed?',
'complaint', 'medium', 'open', '2025-01-19 11:00:00'),

('TKT-10081', 'Pamela Walker', 'pamela.w@gmail.com', 'Cedar Point Towers', '3B-222',
'Dirty Common Areas',
'The hallways and common areas near unit 3B-222 have not been cleaned in what seems like weeks. There is dust everywhere and the carpet looks stained and dirty. Trash has been left in the hallway for days. This is unacceptable for the rent we pay.',
'complaint', 'medium', 'open', '2025-01-20 10:30:00'),

('TKT-10082', 'Harold Allen', 'harold.a@yahoo.com', 'Lakeside Villas', '9C-618',
'Neighbors Dog Barking All Day',
'The dog in unit 9C-619 next to my unit 9C-618 barks continuously all day while the owner is at work. It starts at 8 AM and goes on until 6 PM. I work from home and it makes it impossible to concentrate on calls. This happens every weekday.',
'complaint', 'medium', 'open', '2025-01-20 15:00:00'),

('TKT-10083', 'Christine Young', 'christine.y@icloud.com', 'Harmony Gardens', '7A-515',
'Trash Not Being Collected',
'The dumpster area at Harmony Gardens has not been serviced in at least 4 days. Trash is overflowing onto the ground. It smells terrible and I have seen rats near the area. I am in unit 7A-515. This is a health hazard and needs immediate attention.',
'complaint', 'medium', 'open', '2025-01-21 07:30:00'),

('TKT-10084', 'Ralph Scott', 'ralph.s@gmail.com', 'Silver Creek Apartments', '2B-209',
'Pool Closed With No Update',
'The community pool has been closed for over a month now with a sign saying under maintenance. There has been no communication about when it will reopen. We pay for amenities as part of our rent in unit 2B-209. Please provide an update or reduce our amenity fee.',
'complaint', 'medium', 'open', '2025-01-21 13:00:00'),

('TKT-10085', 'Marie Adams', 'marie.a@outlook.com', 'Greenfield Residences', '11A-705',
'Security Gate Broken',
'The security gate at the main entrance of Greenfield Residences has been broken and stuck open for a week. Anyone can walk into the property. As a single woman living alone in unit 11A-705 this makes me feel very unsafe. Please fix this immediately.',
'complaint', 'high', 'open', '2025-01-22 08:00:00'),

('TKT-10086', 'Philip Baker', 'philip.b@hotmail.com', 'Sunset Apartments', '6A-420',
'Smoking in Non Smoking Building',
'Someone on my floor is smoking inside their apartment and the smoke is coming through the vents into my unit 6A-420. I have asthma and this is causing me serious health issues. The building is supposed to be non-smoking. Please investigate and enforce the policy.',
'complaint', 'high', 'open', '2025-01-22 16:00:00'),

('TKT-10087', 'Diane Nelson', 'diane.n@gmail.com', 'Oakwood Residences', '10B-630',
'Package Theft in Lobby',
'Multiple packages have been stolen from the lobby area of Oakwood Residences this month. I lost a package worth $200 delivered on 01/15/2025. I live in unit 10B-630. There are no security cameras in the lobby. Something needs to be done about package security.',
'complaint', 'medium', 'open', '2025-01-23 09:00:00'),

('TKT-10088', 'Wayne Mitchell', 'wayne.m@yahoo.com', 'Maple Grove Complex', '3D-225',
'Laundry Room Always Occupied',
'The shared laundry room at Maple Grove Complex only has 3 washers and 3 dryers for over 100 units. There is always a long wait and people leave their clothes in machines for hours. I live in unit 3D-225. Can you add more machines or set time limits?',
'complaint', 'low', 'open', '2025-01-23 12:00:00'),

('TKT-10089', 'Alice Campbell', 'alice.c@icloud.com', 'Pine Valley Estates', '8A-540',
'Unauthorized People Using Gym',
'Non-residents have been using the gym at Pine Valley Estates. I live in unit 8A-540 and I have seen the same group of people who clearly do not live here using the gym equipment every evening. The gym is supposed to be for residents only.',
'complaint', 'low', 'open', '2025-01-24 10:30:00'),

('TKT-10090', 'Roger Hill', 'roger.h@gmail.com', 'Riverdale Heights', '5A-405',
'Water Pressure Too Low',
'The water pressure in unit 5A-405 has been extremely low for the past 2 weeks. Taking a shower takes twice as long and the dishwasher is not cleaning properly. Other tenants on my floor are experiencing the same issue. Please investigate.',
'complaint', 'medium', 'open', '2025-01-24 14:00:00'),


-- =============================================
-- CATEGORY: GENERAL INQUIRY (10 tickets)
-- =============================================

('TKT-10091', 'Jean Cooper', 'jean.c@gmail.com', 'Sunset Apartments', '3A-210',
'Leasing Office Hours',
'What are the current office hours for the leasing office at Sunset Apartments? I need to pick up a package that was delivered there. I work during the day so I need to know if you are open on weekends. I am in unit 3A-210.',
'general_inquiry', 'low', 'open', '2025-01-15 10:30:00'),

('TKT-10092', 'Howard Rivera', 'howard.r@yahoo.com', 'Oakwood Residences', '6B-430',
'Guest Parking Information',
'Is there designated guest parking at Oakwood Residences? I am having family visit this weekend and need 2 parking spots for Friday through Sunday. I live in unit 6B-430. Do guests need parking permits? Where should they park?',
'general_inquiry', 'low', 'open', '2025-01-16 11:00:00'),

('TKT-10093', 'Theresa Evans', 'theresa.e@outlook.com', 'Maple Grove Complex', '9B-610',
'Wall Mounting TV Guidelines',
'I want to mount my TV on the wall in the living room of unit 9B-610. Are there any guidelines or restrictions? Do I need to use specific anchors? Will I be charged for the holes when I move out? Just want to make sure I do it right.',
'general_inquiry', 'low', 'open', '2025-01-17 09:30:00'),

('TKT-10094', 'Carl Phillips', 'carl.p@gmail.com', 'Pine Valley Estates', '11B-715',
'Community Room Reservation',
'I would like to reserve the community room at Pine Valley Estates for a small birthday gathering on 02/15/2025 from 2 PM to 6 PM. I live in unit 11B-715. Is there a reservation fee? How many people can the room hold? What is the booking process?',
'general_inquiry', 'low', 'open', '2025-01-18 14:00:00'),

('TKT-10095', 'Gloria Turner', 'gloria.t@hotmail.com', 'Riverdale Heights', '4D-320',
'Upcoming Community Events',
'Are there any community events planned for February at Riverdale Heights? I moved into unit 4D-320 last month and would love to meet my neighbors. I heard there used to be monthly gatherings. Are those still happening?',
'general_inquiry', 'low', 'open', '2025-01-19 12:00:00'),

('TKT-10096', 'Jerry Robinson', 'jerry.r@gmail.com', 'Cedar Point Towers', '2C-215',
'Smart Thermostat Installation',
'Can I install a smart thermostat like a Nest or Ecobee in unit 2C-215? I want to save on energy costs. Do I need permission from management? Do I need to keep the original thermostat to reinstall when I move out?',
'general_inquiry', 'low', 'open', '2025-01-20 08:00:00'),

('TKT-10097', 'Marilyn James', 'marilyn.j@yahoo.com', 'Lakeside Villas', '7D-510',
'Internet Providers Available',
'I just moved into unit 7D-510 at Lakeside Villas. What internet service providers are available in this building? Is the building wired for fiber optic? Does management have any partnerships or recommended providers?',
'general_inquiry', 'low', 'open', '2025-01-21 10:00:00'),

('TKT-10098', 'Bruce Martin', 'bruce.m@icloud.com', 'Harmony Gardens', '10C-650',
'Renters Insurance Requirement',
'Is renters insurance mandatory for tenants at Harmony Gardens? I live in unit 10C-650. If so what is the minimum coverage required? Do you have any recommended insurance providers? I need to set this up soon.',
'general_inquiry', 'low', 'open', '2025-01-22 11:30:00'),

('TKT-10099', 'Judith Walker', 'judith.w@gmail.com', 'Silver Creek Apartments', '8D-545',
'Community Rules and Regulations',
'Where can I find the updated community rules and regulations for Silver Creek Apartments? I moved into unit 8D-545 recently and want to make sure I am following all the rules. Is there a handbook or online document I can access?',
'general_inquiry', 'low', 'open', '2025-01-23 09:00:00'),

('TKT-10100', 'Roy Garcia', 'roy.garcia@outlook.com', 'Greenfield Residences', '1C-112',
'Large Furniture Delivery',
'I am expecting a large sofa delivery for unit 1C-112 on 02/01/2025. Is there a freight elevator or a specific entrance I should use for large deliveries? Do I need to reserve the elevator? Are there restricted delivery hours I should know about?',
'general_inquiry', 'low', 'open', '2025-01-24 13:00:00');


-- ============================================
-- Step 4: Verify Data
-- ============================================

-- Check total count
SELECT COUNT(*) AS total_tickets FROM support_tickets;

-- Check count by category
SELECT category, COUNT(*) AS count 
FROM support_tickets 
GROUP BY category 
ORDER BY count DESC;

-- Check count by urgency
SELECT urgency, COUNT(*) AS count 
FROM support_tickets 
GROUP BY urgency 
ORDER BY FIELD(urgency, 'high', 'medium', 'low');

-- Check count by status
SELECT status, COUNT(*) AS count 
FROM support_tickets 
GROUP BY status;

-- Check count by property
SELECT property_name, COUNT(*) AS count 
FROM support_tickets 
GROUP BY property_name 
ORDER BY count DESC;

-- View sample data
SELECT ticket_id, sender_name, category, urgency, 
       LEFT(message, 80) AS message_preview 
FROM support_tickets 
LIMIT 10;