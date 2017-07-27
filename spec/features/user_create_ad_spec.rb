require 'rails_helper'

feature 'User create Ad' do

  scenario 'successfully' do
    user = create(:user)
    create(:profile, user: user)
    login_as(user, scope: :user)

    ad = build(:ad, user: user, requested_knowledge: 'Quero aprender Rails!' )

    visit root_path
    click_on 'Criar Anuncio'

    fill_in 'Conhecimento a adquirir', with: ad.requested_knowledge
    fill_in 'Conhecimento a oferecer', with: ad.offered_knowledge
    fill_in 'Tipo de encontro', with: ad.meeting_type
    fill_in 'Período do dia', with: ad.day_period
    fill_in 'Local do encontro', with: ad.location
    fill_in 'Quando estou disponível', with: ad.avaliability

    click_on 'Enviar'

    #expect strang things
    expect(page).to have_css('h1', text: ad.requested_knowledge)
    expect(page).to have_css('dd', text: ad.offered_knowledge)
    expect(page).to have_css('dd', text: ad.meeting_type)
    expect(page).to have_css('dd', text: ad.day_period)
    expect(page).to have_css('dd', text: ad.location)
    expect(page).to have_css('dd', text: ad.avaliability)
  end

  scenario 'and needs to be loged in' do

    ad = build(:ad)

    visit new_ad_path
    expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))


  end

  scenario 'and can only have one ad' do

    user = create(:user)
    create(:profile, user: user)
    login_as(user, scope: :user)
    ad = create(:ad, user: user)


    visit new_ad_path

    expect(page).to have_content('Voce ja tem um anuncio ativo')
  end

  scenario 'and trie to create a second ad' do

    user = create(:user)
    create(:profile, user: user)
    login_as(user, scope: :user)
    ad = create(:ad, user: user)

    visit root_path


    expect(page).not_to have_content('Criar Anuncio')

  end


end
