Feature: Service ticket validation
  To enforce user authentication in their applications
  Application developers
  Need this library to properly validate service tickets.

  Scenario: Service tickets issued by the CAS server are valid
    When a user logs into CAS as "right" / "right"
    And requests a service ticket for "https://service.example.edu"

    Then that service ticket should be valid

  Scenario: Service tickets not issued by the CAS server are invalid
    When the service ticket "ST-bad" is checked for "https://service.example.edu"

    Then that service ticket should not be valid

  Scenario: Service tickets issued for one service but presented for another are invalid
    When a user logs into CAS as "right" / "right"
    And requests a service ticket for "https://service.example.edu"
    But presents the service ticket to "https://other.example.edu"

    Then that service ticket should not be valid
