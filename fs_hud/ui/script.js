window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.type === "updateVehicle") {
        let vehicleHud = document.getElementById('vehicle-hud');
        if (data.inVehicle) {
            vehicleHud.style.display = "block";
            document.getElementById('speed').innerHTML = data.speed;
            document.getElementById('gear').innerHTML = data.gear;
            if (data.fuel !== undefined) {
                document.getElementById('fuel-fill').style.height = data.fuel + "%";
            }
            updateSpeedBar(data.speed);
        } else {
            vehicleHud.style.display = "none";
        }
    }

    if (data.type === "updateStatus") {
        let healthBar = document.getElementById('health-bar');
        
        // Update Health breedte
        healthBar.style.width = data.health + "%";

        // DAMAGE EFFECT: Als health laag is (< 25%), maak de balk rood
        if (data.health <= 25) {
            healthBar.style.backgroundColor = "#ff4d4d"; // Fel rood
            healthBar.style.boxShadow = "0 0 10px #ff4d4d"; // Rode gloed
        } else {
            healthBar.style.backgroundColor = "white"; // Normaal wit
            healthBar.style.boxShadow = "none";
        }

        // Update Hunger & Thirst
        document.getElementById('hunger-val').innerHTML = Math.round(data.hunger) + "%";
        document.getElementById('thirst-val').innerHTML = Math.round(data.thirst) + "%";

        healthBar.classList.add('low-health'); // Start knipperen
        // En bij de 'else':
        healthBar.classList.remove('low-health'); // Stop knipperen
    }
}); // <--- DEZE WAS JE VERGETEN (sluit de listener af)

function updateSpeedBar(speed) {
    const container = document.getElementById('speed-bar-container');
    if (!container) return;
    container.innerHTML = '';
    for (let i = 0; i < 20; i++) {
        let div = document.createElement('div');
        if (speed > (i * 10)) { div.classList.add('active'); }
        container.appendChild(div);
    }
}