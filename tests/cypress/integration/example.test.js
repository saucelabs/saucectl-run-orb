context('Actions', () => {
  beforeEach(() => {
      cy.visit('https://www.saucedemo.com')
  })
  it('should be able to test loading of login page', () => {
    const screen = cy.get('#login_button_container');
    screen.should('be.visible');
  });
})