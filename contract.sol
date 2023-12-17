// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CarbonEmissionTracker
 * @dev Tracks carbon emissions of an account
 */
contract CarbonEmissionTracker {
  struct EmissionRecord {
    uint256 timestamp;  // timestamp of emission recorded
    uint256 amount;     // amount of emission recorded in parts per million (ppm)
    string category;    // type of emission recorded
  }

  // Mapping of account to emission records
  mapping(address => EmissionRecord[]) private emissions;

  /**
   * @dev Records an emission
   * @param amount The amount of emission to record in parts per million (ppm)
   * @param category The category of emission to record
   */
  function recordEmissions(uint256 amount, string memory category) public {
    emissions[msg.sender].push(EmissionRecord(block.timestamp, amount, category));
  }

  /**
   * @dev Gets the emissions of an account
   * @param account The account to get the emissions of
   * @return The emissions of the account
   */
  function getEmissions(address account) public view returns (EmissionRecord[] memory) {
    return emissions[account];
  }

  /**
   * @dev Calculates the total carbon emission of an account
   * @param account The account to calculate the total carbon emission of
   * @return The total carbon emission of the account
   */
  function getTotalEmissions(address account) public view returns (uint256) {
    uint256 totalEmission = 0;
    EmissionRecord[] memory accountEmissions = emissions[account];
    for (uint256 i = 0; i < accountEmissions.length; i++) {
      totalEmission += accountEmissions[i].amount;
    }
    return totalEmission;
  }

  /**
   * @dev Calculates the total carbon emission of an account in a given category
   * @param account The account to calculate the total carbon emission of
   * @param category The category to calculate the total carbon emission of
   * @return The total carbon emission of the account in the given category
   */
  function getTotalEmissionsByCategory(address account, string memory category) public view returns (uint256) {
    uint256 totalEmission = 0;
    EmissionRecord[] memory accountEmissions = emissions[account];
    for (uint256 i = 0; i < accountEmissions.length; i++) {
      if (keccak256(abi.encodePacked(accountEmissions[i].category)) == keccak256(abi.encodePacked(category))) {
        totalEmission += accountEmissions[i].amount;
      }
    }
    return totalEmission;
  }

  /**
   * @dev Calculates the total carbon emission of an account in a given time period
   * @param account The account to calculate the total carbon emission of
   * @param startTime The start time of the time period
   * @param endTime The end time of the time period
   * @return The total carbon emission of the account in the given time period
   */
  function getTotalEmissionsByTimePeriod(address account, uint256 startTime, uint256 endTime) public view returns (uint256) {
    uint256 totalEmission = 0;
    EmissionRecord[] memory accountEmissions = emissions[account];
    for (uint256 i = 0; i < accountEmissions.length; i++) {
      if (accountEmissions[i].timestamp >= startTime && accountEmissions[i].timestamp <= endTime) {
        totalEmission += accountEmissions[i].amount;
      }
    }
    return totalEmission;
  }
  
  /**
  * @dev Calculates the carbon emissions based on amount and emission factor
  * @param amount The amount of the business operation (e.g. kWh of electricity used)
  * @param emissionFactor The emission factor to use for calculation (e.g. kg CO2e/kWh)
  * @return The calculated carbon emissions in metric tons
  */
  function calculateCarbonEmissions(uint256 amount, uint256 emissionFactor) public pure returns (uint256) {
    // as solidity does not support floating point numbers, we record the emission factor in parts per million (ppm)
    return amount * emissionFactor;
  }
}
